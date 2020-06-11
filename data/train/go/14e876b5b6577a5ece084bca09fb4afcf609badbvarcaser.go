// Package varcaser provides a way to change the case of variable names.
//
//     result := Caser{From: LowerCamelCase, To: KebabCase}.String("someInitMethod")
//     // "some-init-method"
//     result := Caser{From: LowerCamelCase,
//           To: ScreamingSnakeCase}.String("myConstantVariable")
//     // "MY_CONSTANT_VARIABLE"
package varcaser

import "strings"

var LowerSnakeCase = CaseConvention{
	JoinStyle:      SimpleJoinStyle("_"),
	InitialCase:    strings.ToLower,
	SubsequentCase: strings.ToLower,
	Example:        "lower_snake_case",
}

var ScreamingSnakeCase = CaseConvention{
	JoinStyle:      SimpleJoinStyle("_"),
	InitialCase:    strings.ToUpper,
	SubsequentCase: strings.ToUpper,
	Example:        "SCREAMING_SNAKE_CASE",
}

var KebabCase = CaseConvention{
	JoinStyle:      SimpleJoinStyle("-"),
	InitialCase:    strings.ToLower,
	SubsequentCase: strings.ToLower,
	Example:        "kebab-case",
}

var UpperKebabCase = CaseConvention{
	JoinStyle:      SimpleJoinStyle("-"),
	InitialCase:    ToStrictTitle,
	SubsequentCase: ToStrictTitle,
	Example:        "Upper-Kebab-Case",
}

var ScreamingKebabCase = CaseConvention{
	JoinStyle:      SimpleJoinStyle("-"),
	InitialCase:    strings.ToUpper,
	SubsequentCase: strings.ToUpper,
	Example:        "SCREAMING-KEBAB-CASE",
}

var HttpHeaderCase = CaseConvention{
	JoinStyle:      SimpleJoinStyle("-"),
	InitialCase:    ToHttpTitle,
	SubsequentCase: ToHttpTitle,
	Example:        "HTTP-Header-Case",
}

var UpperCamelCase = CaseConvention{
	JoinStyle:      camelJoinStyle,
	InitialCase:    ToStrictTitle,
	SubsequentCase: ToStrictTitle,
	Example:        "UpperCamelCase",
}

var LowerCamelCase = CaseConvention{
	JoinStyle:      camelJoinStyle,
	InitialCase:    strings.ToLower,
	SubsequentCase: ToStrictTitle,
	Example:        "lowerCamelCase",
}

var UpperCamelCaseKeepCaps = CaseConvention{
	JoinStyle:      camelJoinStyle,
	InitialCase:    strings.Title,
	SubsequentCase: strings.Title,
	Example:        "UpperCamelCase",
}

var LowerCamelCaseKeepCaps = CaseConvention{
	JoinStyle:      camelJoinStyle,
	InitialCase:    strings.ToLower,
	SubsequentCase: strings.Title,
	Example:        "lowerCamelCase",
}
