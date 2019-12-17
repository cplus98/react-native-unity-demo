module.exports = {
	"root": true,
	"env": {
		"es6": true,
		"node": true,
		"browser": true,
		"jest": true
	},
	"extends": [
		"eslint:recommended",
		"plugin:@typescript-eslint/eslint-recommended",
		"plugin:prettier/recommended",
	],
	"parser": "@typescript-eslint/parser",
	"parserOptions": {
		"ecmaVersion": 2018,
		"sourceType": "module"
	},
	"rules": {
		// Basic --------------------------------------------------
		"vars-on-top": "off",
		"no-confusing-arrow": "off",
		"wrap-iife": "off",
		"quotes": ["error", "single", { "avoidEscape": true }],
		"import/prefer-default-export": "off",
		"import/no-unresolved": "off",
		"import/no-mutable-exports": "off",
		"import/no-absolute-path": "off",
		"import/no-extraneous-dependencies": "off",
		"no-empty-function": "error",

		// For Prettier --------------------------------------------------
		"indent": "off",
		"implicit-arrow-linebreak": "off",
		"comma-dangle": "off",
		"semi": "off",
		"key-spacing": "off",
		"object-curly-spacing": "off",
		// "indent": ["error", "tab", { "SwitchCase": 1, "VariableDeclarator": "first" }],

		// Legacy --------------------------------------------------
		"no-tabs": "off",
		"max-len": "off",
		'max-params': "off",
		"no-plusplus": "off",

		// Node --------------------------------------------------
		"callback-return": "off",
		// "handle-callback-err": "off",
		// "no-mixed-requires": ["off", false],
		// "no-new-require": "off",
		// "no-path-concat": "off",
		// "no-process-exit": "off",
		// "no-restricted-modules": "off",
		// "no-sync": "off",
		"no-console": "off",
		"no-param-reassign": "off",
		"no-useless-concat": "off",

		// Style --------------------------------------------------
		"linebreak-style": ["error", "unix"],
		"operator-linebreak": "off",
		"no-continue": "off",
		"global-require": "off",
		// "func-names": "off",
		"arrow-parens": ["error", "as-needed"],
		// "import/newline-after-import": "off",
		// "prefer-template": "warn",
		// "guard-for-in": "off",
		"no-unused-expressions": "off",
		// "no-restricted-syntax": "off",
		"no-underscore-dangle": "off",
		"no-useless-escape": "off",
		"object-curly-newline": "off",
		"no-use-before-define": "off",
		"no-empty": "warn",
		"no-lone-blocks": "warn",
		// "prefer-object-spread": "off",
		"camelcase": "warn",
		// "space-before-function-paren": ["error", { "anonymous": "always", "named": "never", "asyncArrow": "always" }],
		"spaced-comment": "off",
		"default-case": "off",
		"prefer-arrow-callback": "error",
		"func-style": ["error", "declaration", { "allowArrowFunctions": true }],
		"jsx-a11y/accessible-emoji": "off",
		// "spaced-comment": ["error", "always", { "exceptions": ["-", "*"], 'markers': ['=', '!'] }],

		// Variables --------------------------------------------------
		// "no-shadow": "off",
		// "no-var": "warn",
		"prefer-const": "error",
		// "no-unused-vars": ["error", { "vars": "local", "args": "none", "ignoreRestSiblings": false }],
		"no-unused-vars": "off",
		// "one-var-declaration-per-line": ["error", "initializations"],
		// "no-multi-assign": "off",
	}
};