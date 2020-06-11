<ul class="simple-list">
    <? foreach ($customers as $c) {
        $hrId = 'customer-vehicles-'.$c['Customer']['id'];
        $imgSgte = $this->Html->image('next.png',array('width'=>'20'));
        $customerName = $this->Js->link(
                $c['Customer']['name'].$imgSgte,
                '/vehicles/customer/'.$c['Customer']['id'],
                array(
                'class'   => 'alto3em',
                'escape'  => false,
                'customer'=> $c['Customer']['id'],
                'update'  => '#vehicle-search-box',
        ));
        $customerId = $c['Customer']['id'];
        echo "<li class='hover-highlight'>$customerName</li>";
    }
    ?>
</ul>