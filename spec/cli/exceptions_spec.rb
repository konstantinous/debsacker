# encoding: utf-8
describe Requirements do

  describe 'valid?' do

    it 'sholud return false' do
      expect(Requirements.valid?).to be(false)
    end

    it 'should raise ENOENT exception cose we have no control' do
      allow(File).to receive(:exist?).and_return(true)
      expect { Requirements.valid? }.to raise_error(Errno::ENOENT, 'No such file or directory - debian/control')
    end

    it 'should return false if we have no installed packages' do
      allow(File).to receive(:readlines).with('debian/control').and_return(['Build-Depends: cow, apt'])
      allow(File).to receive(:exist?).and_return(true)
      allow(SystemGateway).to receive(:perform_with_exit_code).and_return(false)
      expect(Requirements.valid?).to be(false)
    end

  end

end

describe Upackage do

  context 'when no permissions' do

    it 'can\'t read changelog file' do
      allow(File).to receive(:open).with('debian/changelog','a').and_raise(Errno::EACCES)
      expect(Creator.create).to eq('Can\'t create debian/changelog file...')
    end

  end

end
