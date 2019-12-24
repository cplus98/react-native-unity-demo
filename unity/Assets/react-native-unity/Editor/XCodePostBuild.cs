#if UNITY_IOS

using System;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using System.Text;

using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using Application = UnityEngine.Application;

/// <summary>
/// Adding this post build script to Unity project enables Unity iOS build output to be embedded
/// into existing Xcode Swift project.
///
/// However, since this script touches Unity iOS build output, you will not be able to use Unity
/// iOS build directly in Xcode. As a result, it is recommended to put Unity iOS build output into
/// a temporary directory that you generally do not touch, such as '/tmp'.
///
/// In order for this to work, necessary changes to the target Xcode Swift project are needed.
/// Especially the 'AppDelegate.swift' should be modified to properly initialize Unity.
/// See https://github.com/jiulongw/swift-unity for details.
/// </summary>
public static class XcodePostBuild
{
	/// <summary>
	/// Path to the root directory of Xcode project.
	/// This should point to the directory of '${XcodeProjectName}.xcodeproj'.
	/// It is recommended to use relative path here.
	/// Current directory is the root directory of this Unity project, i.e. the directory of 'Assets' folder.
	/// Sample value: "../xcode"
	/// </summary>
	// private const string XcodeProjectRoot = "./build/ios";

	/// <summary>
	/// Name of the Xcode project.
	/// This script looks for '${XcodeProjectName} + ".xcodeproj"' under '${XcodeProjectRoot}'.
	/// Sample value: "DemoApp"
	/// </summary>
	// private static string XcodeProjectName = Application.productName;

	/// <summary>
	/// Directories, relative to the root directory of the Xcode project, to put generated Unity iOS build output.
	/// </summary>
	// private static string ClassesProjectPath = "UnityExport/Classes";
	// private static string LibrariesProjectPath = "UnityExport/Libraries";
	// private static string DataProjectPath = "UnityExport/Data";

	/// <summary>
	/// Path, relative to the root directory of the Xcode project, to put information about generated Unity output.
	/// </summary>
	// private static string ExportsConfigProjectPath = "UnityExport/Exports.xcconfig";

	// private static string PbxFilePath = XcodeProjectName + ".xcodeproj/project.pbxproj";

	private const string BackupExtension = ".bak";

	/// <summary>
	/// The identifier added to touched file to avoid double edits when building to existing directory without
	/// replace existing content.
	/// </summary>
	private const string TouchedMarker = "react-native-unity";

	[PostProcessBuild]
	public static void OnPostBuild(BuildTarget target, string pathToBuiltProject)
	{
		if (target != BuildTarget.iOS)
		{
			return;
		}

		PatchUnityNativeCode(pathToBuiltProject);
	}

	/// <summary>
	/// Make necessary changes to Unity build output that enables it to be embedded into existing Xcode project.
	/// </summary>
	private static void PatchUnityNativeCode(string pathToBuiltProject)
	{
		EditUnityViewMM(Path.Combine(pathToBuiltProject, "Classes/UI/UnityView.mm"));
	}

	/// <summary>
	/// Edit 'UnityView.mm': Unity introduces its own 'LaunchScreen.storyboard' since 2017.3.0f3.
	/// Disable it here and use Swift project's launch screen instead.
	/// </summary>
	private static void EditUnityViewMM(string path)
	{
		var inScope = false;
		var level = 0;
		var markerDetected = false;

		// Add static GetAppController
		EditCodeFile(path, line =>
		{
			inScope |= line.Contains("- (void)layoutSubviews");
			markerDetected |= inScope && line.Contains(TouchedMarker);

			if (inScope && !markerDetected)
			{
				if (line.Trim() == "{")
				{
					level++;
				}
				else if (line.Trim() == "}")
				{
					level--;
				}

				if (line.Trim() == "}" && level == 0)
				{
					inScope = false;
				}

				if (level == 1 && line.Trim().StartsWith("if (_surfaceSize.width != self.bounds.size.width || _surfaceSize.height != self.bounds.size.height)"))
				{
					inScope = false;

					return new string[]
					{
						"	// Added by " + TouchedMarker,
						"	// Unity bug fixed. (Rendering view sizing failure with navigation controls.)",
						"	if (_surfaceSize.width < self.bounds.size.width)",
						"		[self setFrame:CGRectMake(0, 0, self.bounds.size.width * 0.5f, self.bounds.size.height  * 0.5f)];",
						"",
						line
					};
				}
			}

			return new string[] { line };
		});
	}

	/// <summary>
	/// Compares the directories. Returns files that exists in src and
	/// extra files that exists in dest but not in src any more. 
	/// </summary>
	private static void CompareDirectories(string src, string dest, out string[] srcFiles, out string[] extraFiles)
	{
		srcFiles = GetFilesRelativePath(src);

		var destFiles = GetFilesRelativePath(dest);
		var extraFilesSet = new HashSet<string>(destFiles);

		extraFilesSet.ExceptWith(srcFiles);
		extraFiles = extraFilesSet.ToArray();
	}

	private static string[] GetFilesRelativePath(string directory)
	{
		var results = new List<string>();

		if (Directory.Exists(directory))
		{
			foreach (var path in Directory.GetFiles(directory, "*", SearchOption.AllDirectories))
			{
				var relative = path.Substring(directory.Length).TrimStart('/');
				results.Add(relative);
			}
		}

		return results.ToArray();
	}

	private static bool ShouldExcludeFile(string fileName)
	{
		if (fileName.EndsWith(BackupExtension, StringComparison.OrdinalIgnoreCase))
		{
			return true;
		}

		return false;
	}

	private static void EditCodeFile(string path, Func<string, string> lineHandler)
	{
		EditCodeFile(path, line =>
		{
			return new string[] { lineHandler(line) };
		});
	}

	private static void EditCodeFile(string path, Func<string, IEnumerable<string>> lineHandler)
	{
		var bakPath = path + BackupExtension;
		if (File.Exists(bakPath))
		{
			File.Delete(bakPath);
		}

		File.Move(path, bakPath);

		using (var reader = File.OpenText(bakPath))
		using (var stream = File.Create(path))
		using (var writer = new StreamWriter(stream))
		{
			string line;
			while ((line = reader.ReadLine()) != null)
			{
				var outputs = lineHandler(line);
				foreach (var o in outputs)
				{
					writer.WriteLine(o);
				}
			}
		}
	}
}

#endif