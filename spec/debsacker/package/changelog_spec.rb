describe Debsacker::Package::Changelog do
  it 'should generate changelog file' do
    allow(Debsacker::SystemGateway).to receive(:perform).and_return('bug closed #123123')
    allow(File).to receive(:basename).and_return('omg-cashier')

    changelog = described_class.new
    changelog.project_name = 'Debsacker'
    changelog.author = 'debsacker <info@debsacker.com>'

    lines=[ 'Debsacker (1.2.1) stable; urgency=medium',
            ' * bug closed #123123',
            " -- Made by debsacker <info@debsacker.com> #{ DateTime.now.strftime('%a, %e %b %Y %T %z') }"]
    expect(changelog.lines('1.2.1')).to eq(lines)
  end
end