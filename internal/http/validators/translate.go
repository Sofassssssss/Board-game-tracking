package validators

import (
	"errors"
	"fmt"

	"github.com/go-playground/validator/v10"
)

func TranslateValidationErrs(err error) map[string]string {
	var validationErrors validator.ValidationErrors
	if !errors.As(err, &validationErrors) {
		return map[string]string{
			"error": "Invalid validation error format",
		}
	}

	errorMessages := make(map[string]string)
	for _, fieldError := range validationErrors {
		switch fieldError.Tag() {
		case "required":
			errorMessages[fieldError.Field()] = "This field is required"
		case "email":
			errorMessages[fieldError.Field()] = "Invalid email format"
		case "min":
			errorMessages[fieldError.Field()] = fmt.Sprintf("Minimum length is %s", fieldError.Param())
		case "password":
			errorMessages[fieldError.Field()] = "Password must contain at least one uppercase letter, one lowercase letter, one special symbol and one number"
		default:
			errorMessages[fieldError.Field()] = fieldError.Tag()
		}
	}

	return errorMessages
}
