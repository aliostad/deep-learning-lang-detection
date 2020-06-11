<div class="our-service-head">
    <h2>OUR SERVICES</h2>
</div>
<div class="our-service">
	<div class="service-pic clear">
        <a href="" ></a>
        <?php for ($serviceNo=1; $serviceNo <= $totalService ; $serviceNo++) : ?>
           <div class="service-picture" 
                data-target="#modal-service-<?=$serviceNo?>" 
                data-toggle="modal" 
                id="service-pic-<?=$serviceNo?>" pic-name="0<?=$serviceNo?>"></div>
        <?php endfor; ?>
	</div>
	<div class="service-read-more">
		<img src="photo/our-service/button-read-more-en.png">
	</div>
</div>