# Proyecto AWS WAF para E-commerce



Este proyecto implementa un **Web Application Firewall (WAF)** en AWS con **Terraform**, diseñado para proteger un e-commerce de ropa frente a ataques comunes en aplicaciones web.  

Está orientado a cumplir buenas prácticas de **seguridad y cumplimiento normativo** (PCI-DSS, ISO 27001), garantizando **alta disponibilidad, escalabilidad y visibilidad de tráfico malicioso**.



---

## 🚀 Arquitectura

## 📊 Diagrama de Arquitectura
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/1683b507-117d-4b4c-a1c9-cf928e03da1b" />





- **Terraform** para IaC (Infrastructure as Code).

- **AWS WAFv2** con Web ACL para **CloudFront**.

- **CloudWatch Logs** para centralizar y auditar registros.

- **Reglas administradas de AWS**:
- &nbsp; - Common Rule Set (protección general).
- &nbsp; - Known Bad Inputs.
- &nbsp; - IP Reputation List.
- &nbsp; - Anonymous IP List.
- &nbsp; - SQL Injection (SQLi).
- &nbsp; - Cross-Site Scripting (XSS).

- **Controles adicionales**:

- &nbsp; - CAPTCHA en rutas críticas (`/login`, `/signup`, `/checkout`).

- &nbsp; - Rate limiting por IP.

- &nbsp; - Logging con **redacción de cabeceras sensibles** (cookies y authorization).



---



## 🔒 Seguridad y Cumplimiento

- Cumple controles recomendados por **PCI-DSS** para aplicaciones expuestas a internet.
- Integración de **reglas OWASP** proporcionadas por AWS.
- **Protección de datos sensibles** con redacción de headers en logs.

- Arquitectura alineada con los principios de **ISO 27001**:  

&nbsp; - **Disponibilidad** → uso de CloudFront + WAF.  

&nbsp; - **Confidencialidad** → protección contra exfiltración vía reglas de inyección.  

&nbsp; - **Integridad** → control de inputs y tráfico malicioso.



---

## ⚙️ Uso del Proyecto

Clonar el repositorio:

```bash

git clone https://github.com/DiegoJimenez14/waf-demo-diego-jimenez.git

cd waf-demo-diego-jimenez/infra

---

## 📚 Caso de Uso: E-commerce protegido con AWS WAF

Este proyecto no es solo un despliegue técnico, sino un **ejemplo práctico de cómo asegurar una plataforma de e-commerce en AWS**:

- 🛡️ **Protección contra OWASP Top 10**:  
  - SQL Injection → bloqueado por `AWSManagedRulesSQLiRuleSet`.  
  - Cross-Site Scripting → bloqueado por `AWSManagedRulesCrossSiteScriptingRuleSet`.  
  - Malos inputs y exploits → cubiertos por `KnownBadInputs`.  

- 🤖 **Defensa contra bots y tráfico sospechoso**:  
  - Bloqueo de IPs maliciosas conocidas (IP Reputation).  
  - Bloqueo de proxies/tor (Anonymous IP List).  
  - CAPTCHA en `/login`, `/signup` y `/checkout` para frenar ataques de **credential stuffing** y fraude.  

- 🌐 **Alta disponibilidad**:  
  Al integrarse con **CloudFront**, el WAF protege tráfico a nivel global sin impacto en la latencia.  

- 📊 **Visibilidad y auditoría**:  
  Todos los eventos quedan registrados en **CloudWatch Logs**, con redacción de datos sensibles (`authorization`, `cookie`), alineado con **PCI-DSS**.  

- 📈 **Cumplimiento normativo**:  
  La configuración refleja controles exigidos por **ISO 27001** (confidencialidad, integridad y disponibilidad) y **PCI-DSS** (protección de datos de tarjeta y usuarios).  

---

## 🌟 Valor para la organización

Un analista que implementa este WAF garantiza que el e-commerce:  
- **Reduce el riesgo** de ataques que afectan ventas y reputación.  
- **Cumple con estándares de seguridad** requeridos para manejar pagos.  
- **Escala fácilmente** sin perder visibilidad ni control de seguridad.  

Este proyecto demuestra experiencia en **Cloud Security, IaC y cumplimiento** aplicada a un caso real de negocio.

