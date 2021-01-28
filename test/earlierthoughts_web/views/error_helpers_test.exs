defmodule EarlierThoughtsWeb.ErrorHelpersTest do
  use ExUnit.Case

  alias EarlierThoughtsWeb.ErrorHelpers
  import Mock

  test_with_mock(
    "error tag generated",
    Gettext,
    [],
    dgettext: fn _, _, msg, _ -> msg end
  ) do
    alias Phoenix.HTML.Form

    form_struct = %Form{
      action: "#",
      data: %{:name => "value"},
      errors: [name: {"uh oh error", []}],
      hidden: [],
      id: "id",
      impl: __MODULE__,
      index: nil,
      name: "form_name",
      options: [],
      params: %{"name" => "value"},
      source: :test
    }

    [safe: iodata] = ErrorHelpers.error_tag(form_struct, :name)

    assert Phoenix.HTML.safe_to_string({:safe, iodata}) =~
             "uh oh error"
  end

  test_with_mock(
    "plural tag generated",
    Gettext,
    [],
    dngettext: fn _, _, msg, msg, 2, _ -> msg end
  ) do
    alias Phoenix.HTML.Form

    form_struct = %Form{
      action: "#",
      data: %{:name => "value"},
      errors: [name: {"uh oh error", [count: 2]}],
      hidden: [],
      id: "id",
      impl: __MODULE__,
      index: nil,
      name: "form_name",
      options: [],
      params: %{"name" => "value"},
      source: :test
    }

    [safe: iodata] = ErrorHelpers.error_tag(form_struct, :name)

    assert Phoenix.HTML.safe_to_string({:safe, iodata}) =~
             "uh oh error"
  end
end
