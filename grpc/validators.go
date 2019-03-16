package grpc

import (
	validator "gopkg.in/go-playground/validator.v9"
)

func NewValidatorV9Errors(verrs validator.ValidationErrors) []*ValidatorV9Error {
	r := make([]*ValidatorV9Error, len(verrs))
	for i, e := range verrs {
		r[i] = &ValidatorV9Error{
			Tag:             e.Tag(),
			ActualTag:       e.ActualTag(),
			Namespace:       e.Namespace(),
			StructNamespace: e.StructNamespace(),
			Field:           e.Field(),
			StructField:     e.StructField(),
			Kind:            uint32(e.Kind()),
			Type:            e.Type().String(),
			Param:           e.Param(),
		}
	}
	return r
}
