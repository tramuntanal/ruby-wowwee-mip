require 'spec_helper'

describe Wowwee::Mip::Protocol::NotifQueue do

  before(:each) do
    @device= double(:device)
  end
  context "Initialization" do
    it "Should subscribe_to_notifications and start_queue_manager" do
      receive_data_srv= double('receive_data_service')
      expect(receive_data_srv).to receive(:on_notification)
      Wowwee::Mip::Protocol::NotifQueue.new(@device, receive_data_srv)
    end
  end

  class DummyReceiveDataService
    attr_reader :callback
    def on_notification(&proc)
      @callback= proc
    end
  end
  def build_queue
    @receive_data_srv= DummyReceiveDataService.new
    @queue= Wowwee::Mip::Protocol::NotifQueue.new(@device, @receive_data_srv)
  end

  context "Registration" do
    it "Should be able to register on events for a given cmd" do
      build_queue
      observer= double(:observer)
      rs= @queue.register_observer(observer, :software_version)
      software_version_cmd_code= 20
      expect(rs).to eq [software_version_cmd_code]
    end
    it "Should return the registered observer when unregistering from a cmd" do
      build_queue
      observer= double(:observer)
      @queue.register_observer(observer, :software_version)
      rs= @queue.unregister_observer(observer, :software_version)
      expect(rs).to be observer
    end
    it "Should not fail when unregistering a non registered observer" do
      build_queue
      rs= @queue.unregister_observer(double(:observer), :software_version)
      expect(rs).to be nil
    end
  end

  context "On cmd received" do
    SOFTWARE_VERSION_RS= "14133A24"
    it "Should notify all listeners registered to the given event" do
      build_queue
      o1= double(:observer)
      cmd= Wowwee::Mip::Protocol.find_cmd_by_name(:software_version)
      expect(o1).to receive(:observe).with(cmd, [19, 58, 36])
      @queue.register_observer(o1, :software_version)
      o2= double(:observer)
      expect(o2).to receive(:observe).with(cmd, [19, 58, 36])
      @queue.register_observer(o2, :software_version)

      @receive_data_srv.callback.call(SOFTWARE_VERSION_RS)
    end
    it "Should NOT notify listeners registered to other events" do
      build_queue
      o1= double(:observer)
      expect(o1).to receive(:observe)
      @queue.register_observer(o1, :software_version)
      o2= double(:observer)
      expect(o2).to_not receive(:observe)
      @queue.register_observer(o2, :hardware_version)

      @receive_data_srv.callback.call(SOFTWARE_VERSION_RS)
    end
  end

end