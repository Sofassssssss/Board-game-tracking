package validators

import "github.com/go-playground/validator/v10"

func PasswordValidator(fl validator.FieldLevel) bool {
	password := fl.Field().String()
	var hasUpper, hasDigit bool

	for _, c := range password {
		switch {
		case 'A' <= c && c <= 'Z':
			hasUpper = true
		case '0' <= c && c <= '9':
			hasDigit = true
		}
	}

	return hasUpper && hasDigit
}
