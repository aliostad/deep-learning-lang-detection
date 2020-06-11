INSERT db_schema_info (major_no, minor_no, release_no, comments)
VALUES (2,2,7, 'adding product channel size')
GO

CREATE TABLE product_channel_size (
	[model_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[channel_id] [int] NOT NULL,
	[prod_size]	[float] NOT NULL DEFAULT(1)
	CONSTRAINT ModelProdChanSize FOREIGN KEY (model_id)
	REFERENCES model_info(model_id)
	ON DELETE CASCADE
) ON [PRIMARY]
GO

INSERT product_channel_size
SELECT model_info.model_id, product_id, channel_id, 1 as prod_size
FROM model_info, product, channel
WHERE product.model_id = model_info.model_id
AND channel.model_id = model_info.model_id
AND product.brand_id = 1
GO