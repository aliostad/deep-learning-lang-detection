class TestHomoclaveCalculator < Minitest::Test
  def test_calculate_homoclave_for_simple_test_case
    assert_equal('LN', homoclave('Juan', 'Perez', 'Garcia'))
  end

  def test_calculate_same_homoclave_for_names_with_and_without_accents
    assert_equal(homoclave('Juan', 'Pérez', 'García'),
                 homoclave('Juan', 'Perez', 'Garcia'))
  end

  def test_calculate_homoclave_for_person_with_more_than_one_name
    assert_equal('N9', homoclave('Jose Antonio', 'Del real', 'Anzures'))
  end

  def test_calculate_homoclave_for_name_with_n_with_tilde
    assert_equal('T6', homoclave('Juan', 'Muñoz', 'Ortega'))
  end

  def test_calculate_homoclave_for_name_with_multiple_n_with_tilde
    assert_equal('RZ', homoclave('Juan', 'Muñoz', 'Muñoz'))
  end

  def test_calculate_different_homoclave_for_name_with_n_with_tilde_and_without
    refute_equal(homoclave('Juan', 'Munoz', 'Ortega'),
                 homoclave('Juan', 'Muñoz', 'Ortega'))
  end

  def test_calculate_homoclave_for_name_with_u_with_umlaut
    assert_equal('JF', homoclave('Jesus', 'Argüelles', 'Ortega'))
  end

  def test_calculate_same_homoclave_for_name_with_u_with_umlaut_and_without
    assert_equal(homoclave('Jesus', 'Arguelles', 'Ortega'),
                 homoclave('Jesus', 'Argüelles', 'Ortega'))
  end

  def test_calculate_homoclave_for_name_with_ampersand
    assert_equal('2R', homoclave('Juan', 'Perez&Gomez', 'Garcia'))
  end

  def test_calculate_same_homoclave_for_name_with_and_without_special_characters
    assert_equal(homoclave('Juan', 'McGregor', 'OConnorJuarez'),
                 homoclave('Juan', 'Mc.Gregor', "O'Connor-Juarez"))
  end

  def test_calculate_different_homoclave_for_names_with_and_without_ampersand
    refute_equal(homoclave('Juan', 'PerezGomez', 'Garcia'),
                 homoclave('Juan', 'Perez&Gomez', 'Garcia'))
  end

  def test_calculate_same_homoclave_for_different_birthdays
    assert_equal(
      RfcFacil::HomoclaveCalculator.new(RfcFacil::NaturalPerson.new('Juan', 'Perez', 'Garcia', 5, 8, 1987)).calculate,
      RfcFacil::HomoclaveCalculator.new(RfcFacil::NaturalPerson.new('Juan', 'Perez', 'Garcia', 1, 1, 1901)).calculate
    )
  end

  def homoclave(name, firstLastName, secondLastName)
    RfcFacil::HomoclaveCalculator.new(RfcFacil::NaturalPerson.new(name, firstLastName, secondLastName, 1, 1, 1901)).calculate
  end
end
