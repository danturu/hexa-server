describe Messages::BiHash do
  subject { Messages::BiHash.new }

  let(:keys) do
    5.times.map {|i| [:key, i].join(":") }
  end

  let(:objects) do
    5.times.map { Object.new }
  end

  describe "#store" do
    let(:object) { Object.new }

    it "stores uniq objects" do
      subject.store(:key, object)
      subject.store(:key, object)

      expect(subject.get(:key).to_a).to contain_exactly(object)
    end
  end

  context "on keys" do
    before do
      subject.store keys[0], objects.first
      subject.store keys[1], objects.first
      subject.store keys[4], objects.first
      subject.store keys[2], objects.second
      subject.store keys[3], objects.second
      subject.store keys[4], objects.second
    end

    describe "#reverse_get" do
      it "returns empty set for non-existent objects" do
        expect(subject.reverse_get(Object.new)).to eq(Set.new)
      end

      it "returns keys by object" do
        expect(subject.reverse_get(objects.first).to_a).to match_array(keys.values_at(0, 1, 4))
        expect(subject.reverse_get(objects.second).to_a).to match_array(keys.values_at(2, 3, 4))
      end
    end

    describe "#delete" do
      it "should delete key for each object" do
        subject.delete keys[4]

        expect(subject.reverse_get(objects.first).to_a).to match_array(keys.values_at(0, 1))
        expect(subject.reverse_get(objects.second).to_a).to match_array(keys.values_at(2, 3))
      end

      it "returns affected objects" do
        expect(subject.delete(keys[4])).to contain_exactly(objects.first, objects.second)
      end
    end
  end

  context "on objects" do
    before do
      subject.store keys.first,  objects[0]
      subject.store keys.first,  objects[1]
      subject.store keys.first,  objects[4]
      subject.store keys.second, objects[2]
      subject.store keys.second, objects[3]
      subject.store keys.second, objects[4]
    end

    describe "#get" do
      it "returns empty set for non-existent keys" do
        expect(subject.get(:non_existent)).to eq(Set.new)
      end

      it "returns objects by key" do
        expect(subject.get(keys.first).to_a).to match_array(objects.values_at(0, 1, 4))
        expect(subject.get(keys.second).to_a).to match_array(objects.values_at(2, 3, 4))
      end
    end

    describe "#reverse_delete" do
      it "should delete object for each key" do
        subject.reverse_delete objects[4]

        expect(subject.get(keys.first).to_a).to match_array(objects.values_at(0, 1))
        expect(subject.get(keys.second).to_a).to match_array(objects.values_at(2, 3))
      end

      it "returns affected keys" do
        expect(subject.reverse_delete(objects[4])).to contain_exactly(keys.first, keys.second)
      end
    end
  end
end
