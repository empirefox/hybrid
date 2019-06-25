package config

import (
	"reflect"

	"github.com/naoina/toml"
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
