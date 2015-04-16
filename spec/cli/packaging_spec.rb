# encoding: utf-8
describe Debsacker do
  it 'should take version from git tags' do 
    allow(SystemGateway).to receive(:perform).with('git describe --abbrev=0 --tags').and_return('v1.2.1')
    expect(Creator.check_version).to eq('1.2.1')
  end

   it 'should generate changelog file' do
     allow(SystemGateway).to receive(:perform).with('git describe --abbrev=0 --tags').and_return('v1.2.1')
     allow(SystemGateway).to receive(:perform).with('git --no-pager log -1 --oneline').and_return('bug closed #123123')
     allow( File).to receive(:basename).and_return('omg-cashier')
     lines=[ 'test (1.2.1) stable; urgency=medium',
        '  * bug closed #123123',
        " -- Made by debsacker <info@debsacker.com>  #{ DateTime.now.strftime("%a, %e %b %Y %T %z") }"]
     expect(Creator.generate_changelog).to eq(lines)
   end
    
   it 'should install neccesarry packages' do
     allow(File).to receive(:readlines).with('debian/control').and_return(['Build-Depends: apt, cow'])
     allow(File).to receive(:exist?).and_return(true)
     allow(File).to receive(:open).and_return(true)
    [
      "dpkg-query -l apt 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'",
      "dpkg-query -l cow 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'"
    ].each do |command|
      allow(SystemGateway).to receive(:perform_with_exit_code).with(command).and_return(false)
    end
    [
      "apt-get install -q -y apt 2>&1",
      "apt-get install -q -y cow 2>&1"
    ].each do |command|
      expect(SystemGateway).to receive(:perform_with_exit_code).with(command)
    end
  end

  it 'should build package' do
    allow(File).to receive(:readlines).with('debian/control').and_return(['Build-Depends: apt, cow'])
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:open).and_return(true)
    allow(SystemGateway).to receive(:perform).and_return(true)
    allow(SystemGateway).to receive(:perform_with_exit_code).and_return(true)

    [
      "dpkg-query -l apt 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'",
      "dpkg-query -l cow 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'"
    ].each do |command|
      expect(SystemGateway).to receive(:perform_with_exit_code).with(command)
    end
    %w(changelog compat control).each do |file|
        expect(File).to receive(:exist?).with("debian/#{file}")
    end

    Creator.create
  end
end
