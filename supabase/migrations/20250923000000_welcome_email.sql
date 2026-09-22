-- Marca de envío del email de bienvenida (post-confirmación), para no
-- reenviarlo si /auth/confirm se procesa más de una vez.
alter table public.profiles
  add column welcome_email_sent_at timestamptz;
