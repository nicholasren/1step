require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'tmpdir'

describe "java project generator" do  
  %Q{
    project 
    |
    |--src--|--main
    |       |--test
    |--build.gradle
  }

  before(:each) do
    @target_dir = Dir::tmpdir
    @project_name = "foo"
    @project_base = File.join(@target_dir, @project_name)
  end

  it "should layout java project as default" do
    Firstep::Java::ProjectGenerator.new.create(@project_name, @target_dir)
    
    code_base = File.join(@project_base, "src")
    source_base = File.join(code_base, "main")
    test_base = File.join(code_base, "test")
    java_source_base = File.join(source_base, 'java')
    java_test_base = File.join(test_base, 'java')


    File.should be_exist(@project_base)
    File.should be_exist(java_source_base)
    File.should be_exist(java_test_base)
  end

  it "should generate build file" do
    Firstep::Java::ProjectGenerator.new.create("foo", Dir::tmpdir)

    build_file = File.join(@project_base, "build.gradle")

    File.should be_exist(build_file)
    File.open(build_file, 'r') do |file| 
      file.read.should == %Q{apply plugin: 'java'
version = '1.0.0'

repositories {
  mavenCentral()
}

dependencies {
  compile 'com.google.guava:guava:13.0'
  compile 'joda-time:joda-time:2.1'
  testCompile 'junit:junit:4.10'
  testCompile 'org.mockito:mockito-all:1.9.0'
}}
    end
  end
end