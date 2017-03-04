Gem::Specification.new do |s|
  s.name        = 'clinic_finder'
  s.version     = '0.0.0'
  s.date        = '2017-02-23'
  s.summary     = 'Finding abortion clinics based on zip and LMP'
  s.description = 'Help abortion fund case managers match ' \
                  'patients to optimal clinics.'
  s.authors     = ['Team Code for DCAF', 'Colin Fleming', 'Lisa Waldschmitt']
  s.email       = 'info@dcabortionfund.org'
  s.files       = ['lib/clinic_finder.rb', 'lib/clinic_finder/template.rb']
  s.homepage    = 'http://www.dcabortionfund.org'
  s.license     = 'MIT'

  s.rubyforge_project = "clinic_finder"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'geocoder'
end
