package models

type UserGroup struct {
	UserGroupID     int `gorm:"primaryKey;autoIncrement"`
	UserID          uint
	User            User `gorm:"foreignKey:UserID"`
	GroupID         uint
	Group           Group `gorm:"foreignKey:GroupID"`
	UserGroupRoleID uint
	UserGroupRole   GroupRole `gorm:"foreignKey:UserGroupRoleID"`
}
