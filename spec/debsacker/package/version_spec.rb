describe Debsacker::Package::Version do
  it 'should return version with tag name' do
    expect(Debsacker::SystemGateway).to receive(:perform).exactly(2).times.and_return('0.10.0')
    version = described_class.new('tag')

    expect(version.generate).to eq '0.10.0'
  end

  it 'should return version with tag name by default' do
    expect(Debsacker::SystemGateway).to receive(:perform).exactly(2).times.and_return('0.10.0')
    version = described_class.new(nil)

    expect(version.generate).to eq '0.10.0'
  end

  it 'should return version last tag if current git ref is not tag' do
    expect(Debsacker::SystemGateway).to receive(:perform).and_return('master')
    expect(Debsacker::SystemGateway).to receive(:perform).and_return("0.8.0#{ $/ }0.9.0#{ $/ }")
    version = described_class.new('tag')

    expect(version.generate).to eq '0.9.0'
  end

  it 'should return version with commit name' do
    expect(Debsacker::SystemGateway).to receive(:perform).and_return('f232fdf23f2')
    version = described_class.new('commit')

    expect(version.generate).to eq 'f232fdf23f2'
  end

  it 'should return version with datetime' do
    time = Time.now.strftime('%Y%m%d%H%M%S')
    version = described_class.new('datetime')

    expect(version.generate).to eq time
  end

  it 'should return explicit version' do
    version = described_class.new('1.0.0-rc2')

    expect(version.generate).to eq '1.0.0-rc2'
  end

  it 'should add branch name' do
    expect(Debsacker::SystemGateway).to receive(:perform).and_return('master')

    version = described_class.new('1.0.0-rc2')
    version.add_branch = true

    expect(version.generate).to eq '1.0.0-rc2-master'
  end

  it 'should add distro name' do
    expect(Debsacker::SystemGateway).to receive(:perform).and_return('debian')

    version = described_class.new('1.0.0-rc2')
    version.add_branch = true

    expect(version.generate).to eq '1.0.0-rc2-debian'
  end

  it 'should add distro name and branch name' do
    expect(Debsacker::SystemGateway).to receive(:perform).and_return('master')
    expect(Debsacker::SystemGateway).to receive(:perform).and_return('debian')

    version = described_class.new('1.0.0-rc2')
    version.add_branch = true
    version.add_distro = true

    expect(version.generate).to eq '1.0.0-rc2-master-debian'
  end
end