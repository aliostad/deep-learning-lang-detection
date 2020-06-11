#!/bin/sh

function append {
    cat content/$1.md >> apiary.apib
    echo "\n" >> apiary.apib
}

function clear {
    > apiary.apib
}


clear

append overview

append authentication/overview
append authentication/authenticate

append application/overview
append application/new
append application/pre-pop
append application/existing
append application/update
append application/update-payment-basis

append customer/overview
append customer/create
append customer/list
append customer/existing/read
append customer/existing/update
append customer/existing/remove

append product/overview
append product/create
append product/list
append product/existing/read
append product/existing/update
append product/existing/delete

append pre-declaration/overview
append pre-declaration/existing

append enquiry/overview
append enquiry/existing

append question/overview
append question/definition
append question/option-list
append question/option-lookup

append post-declaration/overview
append post-declaration/existing

append comparison/overview
append comparison/list
append comparison/item

append basket/overview
append basket/list
append basket/items
append basket/item
append basket/document

append declaration-of-health/overview
append declaration-of-health/existing

append doctor/overview
append doctor/existing

append payment/overview
append payment/restriction/overview
append payment/restriction/read
append payment/existing/overview
append payment/existing/read
append payment/existing/update

append legals/overview
append legals/advised-sale-declaration
append legals/money-laundering-checked-declaration
append legals/adviser-declaration
append legals/client-declaration
append legals/insurer-marketing-preference
append legals/third-party-marketing-preference
append legals/provider-legal-confirmation

append activation/overview
append activation/list
append activation/plan

append document/overview
append document/existing

append message/overview
append message/list
