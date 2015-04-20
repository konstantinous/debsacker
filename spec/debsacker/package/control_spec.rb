describe Debsacker::Package::Control do
  subject { described_class.new('spec/fixtures/control') }

  its(['Source']) { is_expected.to eq 'debsacker' }
  its(['Section']) { is_expected.to eq 'misc' }
  its(['Priority']) { is_expected.to eq 'optional' }
  its(['Maintainer']) { is_expected.to eq 'debsacker <info@example.com>' }
  its(['Build-Depends']) { is_expected.to eq ['apt', 'cow'] }
  its(['Standards-Version']) { is_expected.to eq '3.8.4' }
  its(['Package']) { is_expected.to eq 'debsacker' }
  its(['Homepage']) { is_expected.to eq 'https://github.com/konstantinous/debsacker' }
  its(['Architecture']) { is_expected.to eq 'amd64' }
  its(['Depends']) { is_expected.to eq 'ruby' }
  its(['Description']) { is_expected.to eq 'Build application as a debian/ubuntu package' }
end