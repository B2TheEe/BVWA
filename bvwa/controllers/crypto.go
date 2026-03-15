package controllers

import (
    "crypto/md5"
    "crypto/sha256"
    "encoding/hex"
    "fmt"
    beego "github.com/beego/beego/v2/server/web"
    "golang.org/x/crypto/bcrypt"
)

type VulnerableCryptoController struct {
    beego.Controller
}

func (c *VulnerableCryptoController) Get() {
    password := "geheim123"
    hash := md5.Sum([]byte(password))

    c.Data["Title"]   = "Cryptographic Failures (Kwetsbaar)"
    c.Data["Method"]  = "MD5"
    c.Data["Hash"]    = fmt.Sprintf("%x", hash)
    c.Data["Warning"] = "MD5 is onveilig!"
    c.Data["SHA"]     = ""
    c.TplName = "crypto/index.tpl"
}

type SecureCryptoController struct {
    beego.Controller
}

func (c *SecureCryptoController) Get() {
    password := "geheim123"

    hash, err := bcrypt.GenerateFromPassword(
        []byte(password), bcrypt.DefaultCost)
    if err != nil {
        c.Data["Title"] = "Cryptographic Failures (Veilig)"
        c.Data["Hash"]  = "Fout: " + err.Error()
        c.Data["SHA"]   = ""
        c.TplName = "crypto/index.tpl"
        return
    }

    sha := sha256.Sum256([]byte("gevoelige data"))

    c.Data["Title"]   = "Cryptographic Failures (Veilig)"
    c.Data["Method"]  = "bcrypt"
    c.Data["Hash"]    = string(hash)
    c.Data["Warning"] = ""
    c.Data["SHA"]     = hex.EncodeToString(sha[:])
    c.TplName = "crypto/index.tpl"
}
