Gem::Specification.new do |s|
  s.name        = 'clinic_finder'
  s.version     = '0.0.2pre'
  s.date        = '2017-02-23'
  s.summary     = 'Finding abortion clinics based on zip and LMP'
  s.description = 'Help abortion fund case managers match ' \
                  'patients to optimal clinics.'
  s.authors     = ['Sara Gilford', 'Claire Schlessinger',
                   'Katherine Bui', 'Sierra McLawhorn',
                   'Colin Fleming', 'Lisa Waldschmitt', 'Team Code for DCAF']
  s.email       = 'info@dcabortionfund.org'
  s.files       = ['lib/clinic_finder.rb',
                   'lib/clinic_finder/geocoder.rb']
  s.homepage    = 'http://www.dcabortionfund.org'
  s.license     = 'MIT'

  s.rubyforge_project = 'clinic_finder'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']
end
