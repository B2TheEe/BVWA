package controllers

import (
    "crypto/md5"  // KWETSBAAR: verouderd algoritme
    "crypto/sha256"
    "fmt"
    beego "github.com/beego/beego/v2/server/web"
)

// KWETSBAAR: gebruikt verouderde/onveilige library
type VulnerableSupplyChainController struct {
    beego.Controller
}

func (c *VulnerableSupplyChainController) Get() {
    // Simuleert gebruik van kwetsbare dependency (MD5)
    data := []byte("gebruikerswachtwoord")
    hash := md5.Sum(data)
    c.Data["Hash"] = fmt.Sprintf("%x", hash)
    c.Data["Title"] = "Supply Chain (Kwetsbaar - MD5)"
    c.Data["Info"] = "MD5 is gebroken en onveilig!"
    c.TplName = "supplychain/index.tpl"
}

// VEILIG: gebruikt moderne, veilige library
type SecureSupplyChainController struct {
    beego.Controller
}

func (c *SecureSupplyChainController) Get() {
    // Veilige dependency: SHA-256
    data := []byte("gebruikerswachtwoord")
    hash := sha256.Sum256(data)
    c.Data["Hash"] = fmt.Sprintf("%x", hash)
    c.Data["Title"] = "Supply Chain (Veilig - SHA-256)"
    c.Data["Info"] = "SHA-256 is modern en veilig."
    c.TplName = "supplychain/index.tpl"
}
