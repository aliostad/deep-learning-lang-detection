require_relative 'app/repositories/customer_repository'
require_relative 'app/repositories/employee_repository'
require_relative 'app/repositories/order_repository'
require_relative 'router'

employee_repository = EmployeeRepository.new('data/employees.csv')
customer_repository = CustomerRepository.new('data/customers.csv')
order_repository    = OrderRepository.new(
  'data/orders.csv',
  customer_repository,
  employee_repository
)

router = Router.new(customer_repository, employee_repository, order_repository)
router.run
