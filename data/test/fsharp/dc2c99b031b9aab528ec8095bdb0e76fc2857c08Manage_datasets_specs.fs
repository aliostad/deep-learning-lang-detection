namespace Manage_datasets

open NUnit.Framework
open Global_configurations.Data_types
open System

module Manage_datasets_specs = 
    module Test_objects = 
        let internal test_dataset = 
                    { Header = 
                        [|"Store"; 
                          "DayOfWeek"; 
                          "Date"; 
                          "Sales"; 
                          "Customers"; 
                          "Open"; 
                          "Promo"; 
                          "StateHoliday"; 
                          "SchoolHoliday"|];
                      Observations = 
                        [|[|"1";"5";"2015-07-31";"5263";"555";"1";"1";"\"0\"";"\"1\""|];
                          [|"2";"5";"2015-07-31";"6064";"625";"1";"1";"\"a\"";"\"1\""|]; 
                          [|"3";"5";"2015-07-31";"8314";"821";"1";"1";"\"0\"";"\"1\""|]|] }

    [<TestFixture>]
    module Parse_specs = 
        [<Test>]
        let The_parser_is_functioning_correctly =
            let expected_result = 
                { Header = 
                    [|"Store"; 
                      "DayOfWeek"; 
                      "Date_year"; 
                      "Date_month"; 
                      "Date_day"; 
                      "Sales"; 
                      "Customers"; 
                      "Open"; 
                      "Promo"; 
                      "StateHoliday_0"; 
                      "StateHoliday_a"; 
                      "SchoolHoliday"|];
                  Observations = 
                    [|[|1;5;2015;7;31;5263;555;1;1;1;0;1|];
                      [|2;5;2015;7;31;6064;625;1;1;0;1;1|];
                      [|3;5;2015;7;31;8314;821;1;1;1;0;1|]|]
                    |> Array.map (fun obs -> 
                        obs |> Array.map (fun elem -> float elem)) }

            //Assert.AreEqual (Parse.String_dataset test_input, expected_result)
            let result = Parse.string_dataset Test_objects.test_dataset
            result = expected_result
    
        [<Test>]
        let Test_date_parse = 
            let test_date = "2015-07-12"
            let expected_result = new DateTime (2015, 07, 12)
            let result = Parse.tryParseDate test_date
            result.Value = expected_result

    [<TestFixture>]
    module Manage_features_specs =
        [<Test>]
        let Test_split_features =
            let expected_result = 
                [| {Name = "Store"; Observations = [|"1";"2";"3"|]};
                   {Name = "DayOfWeek"; Observations = [|"5";"5";"5"|]};
                   {Name = "Date"; Observations = [|"2015-07-31";"2015-07-31";"2015-07-31"|]};
                   {Name = "Sales"; Observations = [|"5263";"6064";"8314"|]};
                   {Name = "Customers"; Observations = [|"555";"625";"821"|]};
                   {Name = "Open"; Observations = [|"1";"1";"1"|]};
                   {Name = "Promo"; Observations = [|"1";"1";"1"|]};
                   {Name = "StateHoliday"; Observations = [|"\"0\"";"\"a\"";"\"0\""|]};
                   {Name = "SchoolHoliday"; Observations = [|"\"1\"";"\"1\"";"\"1\""|]};|]

            let result = Manage_features.split_dataset_to_features Test_objects.test_dataset id Test_objects.test_dataset.Header
            result = expected_result

       