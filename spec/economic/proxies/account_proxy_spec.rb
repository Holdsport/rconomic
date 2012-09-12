require './spec/spec_helper'

describe Economic::AccountProxy do
  let(:session) { make_session }
  subject { Economic::AccountProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".all" do

    it "returns multiple accounts" do
      savon.expects('Account_GetAll').returns(:multiple)
      savon.expects('Account_GetName').returns(:success)
      savon.expects('Account_GetName').returns(:success)
      all = subject.all
      all.size.should == 2
      all[0].should be_instance_of(Economic::Account)
      all[1].should be_instance_of(Economic::Account)
    end

  end

  describe ".get_name" do

    it 'returns an account book with a name' do
      savon.expects('Account_GetName').with("accountHandle" => { "Number" => "52" }).returns(:success)
      result = subject.get_name("52")
      result.should be_instance_of(Economic::Account)
      result.number.should == "52"
      result.name.should be_a(String)
    end

  end

end
