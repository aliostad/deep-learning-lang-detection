/*!40101 SET CHARACTER_SET_CLIENT='utf8' */;
/*!40101 SET NAMES utf8 */;

INSERT INTO `message_types` (`id`, `name`, `title`, `template`, `variables`) VALUES (1, 'new_client', 'Регистрация нового клиента по реферальной ссылке', 'new_client.html', '%%client_name%%');
INSERT INTO `message_types` (`id`, `name`, `title`, `template`, `variables`) VALUES (2, 'new_level', 'Достижение нового уровня', 'new_level.html', '%%level_name%%');
INSERT INTO `message_types` (`id`, `name`, `title`, `template`, `variables`) VALUES (3, 'new_payment', 'Новый платеж от клиента', 'new_payment.html', '%%client_name%%, %%payment_sum%%');
INSERT INTO `message_types` (`id`, `name`, `title`, `template`, `variables`) VALUES (4, 'new_payout', 'Состоялась выплата', 'new_payout.html', '%%payout_sum%%');
INSERT INTO `message_types` (`id`, `name`, `title`, `template`, `variables`) VALUES (5, 'new_ticket', 'При новое тикет сообщение', 'new_ticket.html', '%%ticket_id%%');
