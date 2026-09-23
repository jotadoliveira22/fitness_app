-- Permite borrar una comida registrada (food_logs). Faltaba la policy de
-- delete: solo había select/insert, así que no se podía deshacer un
-- registro cargado por error. food_log_items se borra en cascada.

create policy "food_logs_delete_own"
  on public.food_logs for delete to authenticated using (user_id = auth.uid());
