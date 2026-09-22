const FROM_ADDRESS = process.env.WELCOME_EMAIL_FROM ?? "Sumiva <onboarding@resend.dev>";

function welcomeEmailHtml(firstName: string, siteUrl: string): string {
  const feature = (emoji: string, title: string, body: string) => `
    <tr>
      <td style="padding:14px 0;border-top:1px solid #26292e;">
        <table role="presentation" cellpadding="0" cellspacing="0"><tr>
          <td style="font-size:20px;padding-right:12px;vertical-align:top;">${emoji}</td>
          <td>
            <p style="margin:0;font-size:14px;font-weight:700;color:#ffffff;">${title}</p>
            <p style="margin:4px 0 0 0;font-size:13px;line-height:1.5;color:#9a9c9e;">${body}</p>
          </td>
        </tr></table>
      </td>
    </tr>`;

  return `<!DOCTYPE html>
<html lang="es"><head><meta charset="utf-8" /></head>
<body style="margin:0;padding:0;background-color:#0b0b0c;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#0b0b0c;padding:32px 16px;">
    <tr><td align="center">
      <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:440px;background-color:#161718;border-radius:20px;overflow:hidden;border:1px solid #2a2b2c;">
        <tr><td style="padding:32px 32px 0 32px;text-align:center;">
          <img src="${siteUrl}/brand/sumiva-logo-white.png" alt="Sumiva" width="140" style="display:inline-block;" />
        </td></tr>
        <tr><td style="padding:24px 32px 0 32px;text-align:center;">
          <h1 style="margin:0;font-size:22px;font-weight:800;color:#ffffff;">¡Bienvenido, ${firstName}! 🎉</h1>
          <p style="margin:12px 0 0 0;font-size:14px;line-height:1.6;color:#9a9c9e;">
            Tu cuenta ya está activa. Esto es lo que puedes hacer en Sumiva:
          </p>
        </td></tr>
        <tr><td style="padding:8px 32px 0 32px;">
          <table role="presentation" width="100%" cellpadding="0" cellspacing="0">
            ${feature("🏠", "Inicio", "Tu resumen del día: calorías, macros, entrenamiento planeado y ayuno activo, todo en un vistazo.")}
            ${feature("🏋️", "Entrenamientos", "Planes de entrenamiento adaptados a tu contexto y nivel, con seguimiento de cada sesión.")}
            ${feature("🍽️", "Nutrición", "Registra tus comidas y sigue tus macros contra objetivos personalizados.")}
            ${feature("📈", "Progreso", "Peso, medidas corporales y fotos de evolución para ver tus resultados reales.")}
          </table>
        </td></tr>
        <tr><td style="padding:28px 32px 32px 32px;text-align:center;">
          <a href="${siteUrl}/home" style="display:inline-block;background-color:#c6ff00;color:#0b0b0c;font-weight:700;font-size:15px;text-decoration:none;padding:14px 32px;border-radius:999px;">
            Ir a mi cuenta →
          </a>
        </td></tr>
      </table>
      <p style="margin:20px 0 0 0;font-size:11px;color:#4a4b4c;">Sumiva · Todo suma a tu bienestar</p>
    </td></tr>
  </table>
</body></html>`;
}

/**
 * Envía el email de bienvenida vía la API HTTP de Resend (no depende del
 * SMTP configurado en Supabase Auth, que solo cubre los templates propios
 * de auth como "confirm signup"). Si RESEND_API_KEY no está seteada, no
 * hace nada — deja que el resto del flujo de confirmación siga funcionando.
 */
export async function sendWelcomeEmail(to: string, firstName: string, siteUrl: string): Promise<void> {
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    console.warn("[email] RESEND_API_KEY no configurada, se omite el email de bienvenida.");
    return;
  }

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      from: FROM_ADDRESS,
      to,
      subject: "¡Bienvenido a Sumiva! Todo suma a tu bienestar 🌿",
      html: welcomeEmailHtml(firstName, siteUrl),
    }),
  });

  if (!res.ok) {
    console.error("[email] Falló el envío del email de bienvenida:", res.status, await res.text());
  }
}
