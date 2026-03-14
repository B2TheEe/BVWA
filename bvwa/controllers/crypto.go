package controllers

import (
    "crypto/md5"
    "crypto/sha256"
    "encoding/hex"
    "fmt"
    beego "github.com/beego/beego/v2/server/web"
    "golang.org/x/crypto/bcrypt"
)

// KWETSBAAR: MD5 wachtwoord hashing
type VulnerableCryptoController struct {
    beego.Controller
}

func (c *VulnerableCryptoController) Get() {
    password := "geheim123"
    hash := md5.Sum([]byte(password))
    c.Data["Title"] = "Cryptographic Failures (Kwetsbaar)"
    c.Data["Method"] = "MD5 (gebroken algoritme!)"
    c.Data["Hash"] = fmt.Sprintf("%x", hash)
    c.Data["Warning"] = "MD5 is gekraakt en onveilig voor wachtwoorden!"
    c.TplName = "crypto/index.tpl"
}

// VEILIG: bcrypt wachtwoord hashing
type SecureCryptoController struct {
    beego.Controller
}

func (c *SecureCryptoController) Get() {
    password := "geheim123"
    hash, _ := bcrypt.GenerateFromPassword(
        []byte(password), bcrypt.DefaultCost)
    c.Data["Title"] = "Cryptographic Failures (Veilig)"
    c.Data["Method"] = "bcrypt (sterk algoritme)"
    c.Data["Hash"] = string(hash)
    c.Data["Warning"] = ""

    // Bonus: SHA-256 voor data-integriteit
    sha := sha256.Sum256([]byte("gevoelige data"))
    c.Data["SHA"] = hex.EncodeToString(sha[:])
    c.TplName = "crypto/index.tpl"
}
