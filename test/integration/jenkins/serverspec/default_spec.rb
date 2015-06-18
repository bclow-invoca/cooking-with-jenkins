require "spec_helper"

# FIXME; Jenkins restarts at end of converge,
# FIXME; this does not allow enough time for it to start before these tests run
# FIXME; This is a crappy solution, but it works for the moment.
sleep(60)

describe "jenkins-ci::default" do
end
