<dl>
    <dt>Organisatie</dt>
    <dd>
        <address>
            <?php echo $customer['Customer']['name'] ?><br>
            <?php if (!empty($customer['Customer']['address1'])) { ?>
                <?php echo $customer['Customer']['address1'] ?><br>
            <?php } ?>
            <?php if (!empty($customer['Customer']['address2'])) { ?>
                <?php echo $customer['Customer']['address2'] ?><br>
            <?php } ?>
            <?php if (!empty($customer['Customer']['phone'])) { ?>
                <abbr title="Phone">t:</abbr> <?php echo $customer['Customer']['phone'] ?>
            <?php } ?>
        </address>
    </dd>
    <dt>
        Laatst bewerkt
    </dt>
    <dd>
        <?php echo $customer['Customer']['modified'] ?>
    </dd>
</dl>
