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
  end
end
