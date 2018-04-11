require 'test_helper'

class TestRailsForceReload < RFRTestCase

  test "force_reload on CollectionAssociation" do
    firm = Firm.new("name" => "A New Firm, Inc")
    firm.save
    firm.clients.each {} # forcing to load all clients
    assert firm.clients.empty?, "New firm shouldn't have client objects"
    assert_equal 0, firm.clients.size, "New firm should have 0 clients"

    client = Client.new("name" => "TheClient.com", "firm_id" => firm.id)
    client.save

    assert firm.clients.empty?, "New firm should have cached no client objects"
    assert_equal 0, firm.clients.size, "New firm should have cached 0 clients count"

    assert !firm.clients(true).empty?, "New firm should have reloaded client objects"
    assert_equal 1, firm.clients(true).size, "New firm should have reloaded clients count"
  end

  test "force_reload on SingularAssociation" do
    firm = Firm.new("name" => "A New Firm, Inc")
    firm.save
    firm.user # forcing to load user
    assert_nil firm.user, "New firm shouldn't have user object"

    user = User.new("name" => "Joe Blow", "firm_id" => firm.id)
    user.save

    assert_nil firm.user, "New firm should have cached no user objects"

    refute_nil firm.user(true), "New firm should have reloaded user object"
    assert_instance_of User, firm.user(true), "New firm should now hold a User object"
  end

  test "reload command (still) returns association" do
    firm = Firm.create!("name" => "A New Firm, Inc")
    assert_nothing_raised do
      assert_equal firm.clients, firm.clients.reload.reload
    end
  end

end
