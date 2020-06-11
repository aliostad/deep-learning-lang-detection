<?php

require("Customer.php");
require("CustomerRegistered.php");
require("CustomerUpdatedProfile.php");
// require("CustomerClosedAccount.php");
require("CustomerProjector.php");
require("CustomerRepository.php");
require("Dispatcher.php");

$dispatcher = new Dispatcher();

$repository = new CustomerRepository();

$projector = new CustomerProjector($repository);

$dispatcher->listen(
  "CustomerRegistered",
  [$projector, "customerRegistered"]
);

$dispatcher->listen(
  "CustomerUpdatedProfile",
  [$projector, "customerUpdatedProfile"]
);

$customer = Customer::register(
  $dispatcher,
  "Christopher", "Pitt",
  "chris@connectjoepublic.com"
);

$customer->updateProfile("name", "Chris");

var_dump($customer);