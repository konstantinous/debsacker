# encoding: utf-8
describe 'Requirements errors' do
  describe 'valid?' do
    it 'sholud return false' do
      expect(Debsacker::Requirements.valid?([])).to be(false)
    end

    it 'should return false if we have no installed packages' do
      allow(File).to receive(:exist?).and_return(true)
      allow(Debsacker::SystemGateway).to receive(:perform_with_exit_code).and_return(false)
      expect(Debsacker::Requirements.valid?(['cow', 'apt'])).to be(false)
    end
  end
end

describe 'Creator errors' do
  context 'when no permissions' do
    it 'can\'t read changelog file' do
      allow(File).to receive(:open).with('debian/changelog','w').and_raise(Errno::EACCES)
      expect(Debsacker::Creator.new(double(generate: '0.9.0'), double(:[] => 'Package')).create).to eq('Can\'t create debian/changelog file...')
    end
  end
end
