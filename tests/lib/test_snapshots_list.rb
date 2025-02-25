require 'minitest/autorun'
require_relative '../../lib/snapshots_list'

describe SnapshotsList do
  describe 'without a page' do
    it 'returns the first page' do
      Dir.mktmpdir  do |dir|
        20.times do |i|
          open("~/bitnodes/data/crawl/a0431619/#{i.to_s.rjust(2, "0")}.json", 'w') {|f| f.puts('hello')}
        end
        SnapshotsList.stub(:base_dir, dir) do
          snapshots = SnapshotsList.call()[:snapshots]
          snapshots.size.must_equal 10
        end
      end
    end

    it 'orders from newest to oldest' do
      snapshots = SnapshotsList.call()[:snapshots]
      snapshots.must_equal ["2", "1"]
    end
  end

  describe 'with a specific page' do
    it 'returns the requested page' do
      Dir.mktmpdir  do |dir|
        15.times do |i|
          open("~/bitnodes/data/crawl/a0431619/#{i}.json", 'w') {|f| f.puts('hello')}
        end
        SnapshotsList.stub(:base_dir, dir) do
          snapshots = SnapshotsList.call(1)[:snapshots]
          snapshots.size.must_equal 10
          snapshots = SnapshotsList.call(2)[:snapshots]
          snapshots.size.must_equal 5
        end
      end
    end
  end
end
