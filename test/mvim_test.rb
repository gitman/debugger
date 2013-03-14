if RUBY_PLATFORM =~ /darwin/
require_relative 'test_helper'

describe "Mvim Command" do
  include TestDsl

  it "must open a current file with current frame in MacVim" do
    Debugger::MacVimCommand.any_instance.expects(:`).with("open 'txmt://open?url=file://#{fullpath('mvim')}&line=7'")
    enter 'break 7', 'cont', 'mvim'
    debug_file 'mvim'
  end

  it "must open a current file with specified frame in Texmvim" do
    Debugger::MacVimCommand.any_instance.expects(:`).with("open 'txmt://open?url=file://#{fullpath('mvim')}&line=4'")
    enter 'break 7', 'cont', 'mvim 2'
    debug_file 'mvim'
  end

  describe "errors" do
    it "must show an error message if frame == 0" do
      enter 'mvim 0'
      debug_file 'mvim'
      check_output_includes "Wrong frame number"
    end

    it "must show an error message if frame > max frame" do
      enter 'mvim 10'
      debug_file 'mvim'
      check_output_includes "Wrong frame number"
    end
  end

  describe "Post Mortem" do
    it "must work in post-mortem mode" do
      Debugger::MacVimCommand.any_instance.expects(:`).with(
        "open 'mvim://open?url=file://#{fullpath('post_mortem')}&line=8'"
      )
      enter 'cont', 'mvim'
      debug_file 'post_mortem'
    end
  end
end
end
