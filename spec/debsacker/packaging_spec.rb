# encoding: utf-8
describe 'Packaging' do

   it 'should install neccesarry packages' do
     allow(File).to receive(:exist?).and_return(true)
     allow(File).to receive(:open).and_return(true)
     [
       "dpkg-query -l apt 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'",
       "dpkg-query -l cow 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'"
     ].each do |command|
       allow(Debsacker::SystemGateway).to receive(:perform_with_exit_code).with(command).and_return(false)
     end
     [
       "apt-get install -y -q apt",
       "apt-get install -y -q cow"
     ].each do |command|
       expect(Debsacker::SystemGateway).to receive(:perform_with_exit_code).with(command).and_return(true)
     end

     expect(Debsacker::SystemGateway).to receive(:perform_with_exit_code).with('dpkg-buildpackage -uc -us -b').and_return(true)

     Debsacker::Creator.go(double(generate: '0.1.0'), Debsacker::Package::Control.new('spec/fixtures/control'))
  end

  it 'should build package' do
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:open).and_return(true)
    allow(Debsacker::SystemGateway).to receive(:perform).and_return(true)
    allow(Debsacker::SystemGateway).to receive(:perform_with_exit_code).and_return(true)

    [
      "dpkg-query -l apt 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'",
      "dpkg-query -l cow 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'"
    ].each do |command|
      expect(Debsacker::SystemGateway).to receive(:perform_with_exit_code).with(command)
    end
    %w(changelog compat control).each do |file|
        expect(File).to receive(:exist?).with("debian/#{file}")
    end

    Debsacker::Creator.go(double(generate: '0.1.0'), Debsacker::Package::Control.new('spec/fixtures/control'))
  end
end
