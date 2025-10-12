package auth

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/Sofassssssss/Board-game-tracking/internal/http/validation"
	gormrepo "github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm"
	"github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm/models"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
	"golang.org/x/crypto/bcrypt"
)

func Signup(c *gin.Context) {
	// Get the email/password off req body
	var body struct {
		RoleID   uint   `json:"role_id"`
		Username string `json:"username" validate:"required,ascii,min=3,max=20,excludesall= "`
		Email    string `json:"email" validate:"email"`
		Password string `json:"password" validate:"required,min=8,password"`
	}

	if c.Bind(&body) != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to read body",
		})

		return
	}

	/*
			here we can create special middleware for validation which will work for all project
			It will look like
			if err := validators.Validate.Struct(body); err != nil {
			c.Error(err) /
			return
		}
	*/
	if err := validation.Validate.Struct(body); err != nil {
		errorMessages := validation.TranslateValidationErrs(err)

		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Validation failed",
			"details": errorMessages,
		})
		return
	}

	//Hash the password
	hash, err := bcrypt.GenerateFromPassword([]byte(body.Password), 10)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to hash password",
		})

		return
	}

	// Create the user
	user := models.User{
		RoleID:         body.RoleID,
		Username:       body.Username,
		HashedPassword: string(hash),
		Email:          body.Email,
	}

	result := gormrepo.DB.Create(&user)

	if result.Error != nil {
		var pgErr *pgconn.PgError
		if errors.As(result.Error, &pgErr) {
			fmt.Println("DB error:", result.Error)
			if pgErr.Code == "23505" { // unique_violation
				c.JSON(http.StatusBadRequest, gin.H{
					"error": "User with this email or username already exists",
				})
				return
			}
		}

		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to create user, unknown problem",
		})
		return
	}

	// Respond
	c.JSON(http.StatusCreated, gin.H{})
}
