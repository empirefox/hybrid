package config

import (
	"reflect"

	"github.com/naoina/toml"
	"github.com/naoina/toml/ast"
	strcase "github.com/stoewer/go-strcase"
)

var tc = &toml.Config{
	NormFieldName: func(typ reflect.Type, keyOrField string) string {
		return strcase.UpperCamelCase(keyOrField)
	},
	FieldToKey: func(typ reflect.Type, field string) string {
		return strcase.UpperCamelCase(field)
	},
}

func readVersion(t *ast.Table) string {
	f, ok := t.Fields["Basic"]
	if !ok {
		return ""
	}

	t, ok = f.(*ast.Table)
	if !ok {
		return ""
	}

	f, ok = t.Fields["Version"]
	if !ok {
		return ""
	}

	v, ok := f.(*ast.KeyValue)
	if !ok {
		return ""
	}

	s, ok := v.Value.(*ast.String)
	if !ok {
		return ""
	}

	return s.Value
}
