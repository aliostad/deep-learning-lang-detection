# Escreva um programa que pergunte a quantidade de km percorridos por um 
# carro alugado pelo usuário, assim como a quantidade de dias pelos quais o 
# carro foi alugado. Calcule o preço a pagar, sabendo que o carro custa 
# R$ 60,00 por dia e R$ 0,15 por km rodado.

class CarRent
  DAILY_RENT_VALUE = 60
  KM_RENT_VALUE = 0.15

  def initialize(km=0, days=0)
    @km = km
    @days = days
  end

  def calculate_car_rent_value
    calculate_daily_rent_value + calculate_km_rent_value
  end

  private
  def calculate_daily_rent_value
    @days * DAILY_RENT_VALUE
  end

  def calculate_km_rent_value
    @km * KM_RENT_VALUE
  end
end