Test	What it covers
test_batch_of_one	Single entry, token balance delta, get_schedule retrieval
test_batch_of_five	5 entries, consecutive IDs, all retrievable
test_batch_empty_panics	Empty vec → exact panic message
test_batch_exceeds_limit_panics	21 entries → exact panic message
test_batch_invalid_entry_panics	total_amount = 0 → exact panic message
test_batch_grantor_index	All IDs appear in get_schedules_by_grantor
