require 'pry'
require 'spec_helper'

describe DPt do
  let(:zero) { described_class[0, 0, 0] }
  let(:one) { described_class[1, 1, 1] }
  let(:sx) { described_class[123, 0, 0] }
  let(:sy) { described_class[0, 123, 0] }
  let(:sz) { described_class[0, 0, 123] }
  let(:flat) { described_class[123, 123, 0] }
  let(:big) { described_class[123, 123, 123] }
  let(:neg) { described_class[-123, -123, -123] }

  let(:onex) { described_class[1, 0, 0] }
  let(:oney) { described_class[0, 1, 0] }
  let(:onez) { described_class[0, 0, 1] }

  describe '#spheric' do
    it { expect(zero.spheric).to eq(SPt[0, 0, 0]) }
    it { expect(zero.spheric.descart).to eq(zero) }
    it { expect(one.spheric.descart).to eq(one) }
    it { expect(sx.spheric.descart).to eq(sx) }
    it { expect(sy.spheric.descart).to eq(sy) }
    it { expect(sz.spheric.descart).to eq(sz) }
    it { expect(flat.spheric.descart).to eq(flat) }
    it { expect(big.spheric.descart).to eq(big) }
    it { expect(neg.spheric.descart).to eq(neg) }
  end

  describe '#rotate' do
    it { expect(zero.rotate(30,30,30)).to eq(zero) }
    it { expect(zero.rotate(30,30,30)).equal? (zero) }

    it { expect(onex.rotate(90,0,0)).to eq(onex) }
    it { expect(onex.rotate(0,90,0)).to eq(zero-onez) }
    it { expect(onex.rotate(0,0,90)).to eq(oney) }
    it { expect(oney.rotate(90,0,0)).to eq(onez) }
    it { expect(oney.rotate(0,90,0)).to eq(oney) }
    it { expect(oney.rotate(0,0,90)).to eq(zero-onex) }    
    it { expect(onez.rotate(90,0,0)).to eq(zero-oney) }
    it { expect(onez.rotate(0,90,0)).to eq(onex) }
    it { expect(onez.rotate(0,0,90)).to eq(onez) }

    it { expect((onex+oney).rotate(90,0,0)).to eq(onex+onez) }
    it { expect((onex+oney).rotate(0,90,0)).to eq(oney-onez) }
    it { expect((onex+oney).rotate(0,0,90)).to eq(oney-onex) }
    it { expect((onex+onez).rotate(90,0,0)).to eq(onex-oney) }
    it { expect((onex+onez).rotate(0,90,0)).to eq(onex-onez) }
    it { expect((onex+onez).rotate(0,0,90)).to eq(onez+oney) }    
    it { expect((onez+oney).rotate(90,0,0)).to eq(onez-oney) }
    it { expect((onez+oney).rotate(0,90,0)).to eq(onex+oney) }
    it { expect((onez+oney).rotate(0,0,90)).to eq(onez-onex) }

    it { expect(one.rotate(90,90,90)).to eq(onex+oney-onez) }
  end

end

describe SPt do
  PI = Math::PI

  let(:ang) { PI / 3 }

  let(:zero) { described_class[7, 0, 0] }
  let(:sth) { described_class[7, ang, 0] }
  let(:sp) { described_class[7, 0, ang] }
  let(:flat) { described_class[7, ang, ang] }
  let(:half) { described_class[7, -ang, ang] }
  let(:rev) { described_class[7, ang, -ang] }
  let(:neg) { described_class[7, -ang, -ang] }
  let(:full) { described_class[-7, -ang, -ang] }

  let(:th0p90) { described_class[7, 0, PI / 2] }
  let(:th0p180) { described_class[7, 0, PI] }
  let(:th0p270) { described_class[7, 0, 3 * PI / 2] }
  let(:th180p0) { described_class[7, PI, 0] }
  let(:th180p90) { described_class[7, PI, PI / 2] }
  let(:th180p180) { described_class[7, PI, PI] }
  let(:th180p270) { described_class[7, PI, 3 * PI / 2] }
  let(:th90p0) { described_class[7, PI / 2, 0] }
  let(:th90p90) { described_class[7, PI / 2, PI / 2] }
  let(:th90p180) { described_class[7, PI / 2, PI] }
  let(:th90p270) { described_class[7, PI / 2, 3 * PI / 2] }

  describe '#self.recut' do
    it { expect(SPt.recut(ang, ang)).to eq([ang, ang]) }
    it { expect(SPt.recut(-ang, -ang)).to eq([ang, PI + ang]) }

    it { expect(SPt.recut(-ang, ang)).to eq([ang, PI + ang]) }
    it { expect(SPt.recut(PI + ang, ang)).to eq([PI - ang, ang]) }

    it { expect(SPt.recut(ang, -ang)).to eq([ang, 2 * PI - ang]) }
    it { expect(SPt[7, *SPt.recut(ang, 2 * PI + ang)]).to eq(SPt[7, ang, ang]) } # round
  end

  describe '#descart' do
    it { expect(zero.descart).to eq(DPt[0, 0, 7]) }
    it { expect(zero.descart.spheric).to eq(zero) }
    it { expect(sth.descart.spheric).to eq(sth) }
    it { expect(sp.descart.spheric).to eq(sp) }
    it { expect(flat.descart.spheric).to eq(flat) }
    it { expect(half.descart.spheric).to eq(half) }
    it { expect(rev.descart.spheric).to eq(rev) }
    it { expect(neg.descart.spheric).to eq(neg) }
    it { expect(full.descart.spheric).to eq(full) }

    it { expect(th0p90.descart.spheric).to eq(th0p90) }
    it { expect(th0p180.descart.spheric).to eq(th0p180) }
    it { expect(th0p270.descart.spheric).to eq(th0p270) }
    it { expect(th180p0.descart.spheric).to eq(th180p0) }
    it { expect(th180p90.descart.spheric).to eq(th180p90) }
    it { expect(th180p180.descart.spheric).to eq(th180p180) }
    it { expect(th180p270.descart.spheric).to eq(th180p270) }
    it { expect(th90p0.descart.spheric).to eq(th90p0) }
    it { expect(th90p90.descart.spheric).to eq(th90p90) }
    it { expect(th90p180.descart.spheric).to eq(th90p180) }
    it { expect(th90p270.descart.spheric).to eq(th90p270) }
  end
end
