package handlers

import (
	"errors"
	"fmt"
	gormrepo "github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm"
	"github.com/Sofassssssss/Board-game-tracking/internal/repo/gorm/models"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"os"
	"time"
)

const TokenMaxAge = 30 * 24 * time.Hour

func Signup(c *gin.Context) {
	// Get the email/password off req body
	var body struct {
		RoleID   uint   `json:"role_id"`
		Username string `json:"username"`
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	if c.Bind(&body) != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to read body",
		})

		return
	}

	//TODO: add password, email and username validation

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

func Login(c *gin.Context) {
	// Get the email and password of req body
	var body struct {
		Email    string
		Password string
	}

	if c.Bind(&body) != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to read body",
		})

		return
	}

	// Look up requested user
	var user models.User
	gormrepo.DB.First(&user, "email = ?", body.Email)

	if user.ID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid email",
		})
		return
	}

	// Compare sent in password with saved user password hash
	err := bcrypt.CompareHashAndPassword([]byte(user.HashedPassword), []byte(body.Password))

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid password",
		})
		return

	}

	// Generate a jwt token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": user.ID,
		"exp": time.Now().Add(time.Hour * 24 * 30).Unix(),
	})

	tokenString, err := token.SignedString([]byte(os.Getenv("SECRET")))

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to create token",
		})
		return
	}

	// Send it back
	c.SetSameSite(http.SameSiteLaxMode)
	c.SetCookie(
		"Authorization",
		tokenString,
		int(TokenMaxAge.Seconds()),
		"",
		"",
		false,
		true)

	c.JSON(http.StatusOK, gin.H{})

}

func Validate(c *gin.Context) {
	user, _ := c.Get("user")
	c.JSON(http.StatusOK, gin.H{
		"message": user,
	})
}
