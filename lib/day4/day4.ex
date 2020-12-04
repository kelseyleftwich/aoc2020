defmodule Aoc.Day4 do
  def main(file \\ "input") do
    parse_input(file)
    |> Enum.reduce(0, fn cred, acc ->
      valid? = cred |> validate_cred()

      if valid? do
        acc + 1
      else
        acc
      end
    end)
  end

  def validate_cred(cred) do
    required = [
      # (Birth Year) - four digits; at least 1920 and at most 2002.
      "byr",
      # (Issue Year) - four digits; at least 2010 and at most 2020
      "iyr",
      # (Expiration Year) - four digits; at least 2020 and at most 2030
      "eyr",
      # (Height) - a number followed by either cm or in:
      # If cm, the number must be at least 150 and at most 193.
      # If in, the number must be at least 59 and at most 76
      "hgt",
      # (Hair Color) -  # followed by exactly six characters 0-9 or a-f
      "hcl",
      # (Eye Color) - exactly one of: amb blu brn gry grn hzl oth
      "ecl",
      # (Passport ID) -  a nine-digit number, including leading zeroes.
      "pid"
      # (Country ID)
      # "cid" - ignored, missing or not.
    ]

    cred_keys =
      cred
      |> Map.keys()
      |> Enum.filter(fn key ->
        key in required
      end)

    required_fields_present = Enum.sort(required) == Enum.sort(cred_keys)

    if required_fields_present == true do
      {_cred, is_valid} =
        {cred, true}
        |> validate_birth_year()
        |> validate_issue_year()
        |> validate_expiration_year()
        |> validate_height()
        |> validate_hair_color()
        |> validate_eye_color()
        |> validate_passport_number()

      is_valid
    else
      false
    end
  end

  def validate_passport_number({%{"pid" => pid} = cred, is_valid}) do
    pid_valid = pid |> String.match?(~r/^(\d){9}$/)
    {cred, is_valid and pid_valid}
  end

  def validate_eye_color({%{"ecl" => ecl} = cred, is_valid}) do
    ecl_valid = ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    {cred, is_valid and ecl_valid}
  end

  def validate_hair_color({%{"hcl" => hcl} = cred, is_valid}) do
    hcl_valid = hcl |> String.match?(~r/^#((\d)|(a|b|c|d|e|f)){6}$/)
    {cred, is_valid and hcl_valid}
  end

  def validate_height({%{"hgt" => hgt} = cred, is_valid}) do
    height_valid =
      cond do
        String.ends_with?(hgt, "cm") ->
          parsed_height =
            hgt
            |> String.replace("cm", "")
            |> String.to_integer()

          parsed_height >= 150 and parsed_height <= 193

        String.ends_with?(hgt, "in") ->
          parsed_height =
            hgt
            |> String.replace("in", "")
            |> String.to_integer()

          parsed_height >= 59 and parsed_height <= 76

        true ->
          false
      end

    {cred, is_valid && height_valid}
  end

  def validate_expiration_year({%{"eyr" => eyr} = cred, is_valid}) do
    {cred, is_valid and eyr |> validate_year_range(2020, 2030)}
  end

  def validate_issue_year({%{"iyr" => iyr} = cred, is_valid}) do
    {cred, is_valid and iyr |> validate_year_range(2010, 2020)}
  end

  def validate_birth_year({%{"byr" => byr} = cred, is_valid}) do
    {cred, is_valid and byr |> validate_year_range(1920, 2002)}
  end

  def validate_year_range(year, min, max) do
    {parsed_int, _} = Integer.parse(year)
    parsed_int >= min and parsed_int <= max
  end

  def parse_input(file \\ "input") do
    File.read!("lib/day4/#{file}.txt")
    |> String.split("\n\n")
    |> Stream.map(fn line ->
      line
      |> String.replace("\n", " ")
      |> String.split(" ")
      |> Enum.reduce(%{}, fn str_pair, cred_map ->
        [key, value] = str_pair |> String.split(":")
        Map.put(cred_map, key, value)
      end)
    end)
  end
end
