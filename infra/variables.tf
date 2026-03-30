variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "env" {
  description = "Entorno (dev/prod)"
  type        = string
}

variable "location" {
  description = "Región"
  type        = string
}

variable "alert_email" {
  description = "Correo de alertas"
  type        = string
}