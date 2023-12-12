CREATE TABLE ariel_chumbita_coderhouse.mining_data
(
	mining_algo VARCHAR(20)   ENCODE lzo
	,network_hash_rate VARCHAR(20)   ENCODE lzo
	,available_on_nicehash_percent DOUBLE PRECISION   ENCODE RAW
	,one_hour_attack_cost DOUBLE PRECISION   ENCODE RAW
	,twenty_four_hours_attack_cost DOUBLE PRECISION   ENCODE RAW
	,attack_appeal DOUBLE PRECISION   ENCODE RAW
	,hash_rate DOUBLE PRECISION   ENCODE RAW
	,hash_rate_30d_average DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_per_hash_usd DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_per_hash_native_units DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_per_hash_per_second_usd DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_per_hash_per_second_native_units DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_from_fees_percent_last_24_hours DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_native DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_usd DOUBLE PRECISION   ENCODE RAW
	,mining_revenue_total DOUBLE PRECISION   ENCODE RAW
	,average_difficulty DOUBLE PRECISION   ENCODE RAW
	,date TIMESTAMP WITHOUT TIME ZONE   ENCODE az64
)
DISTSTYLE AUTO
;