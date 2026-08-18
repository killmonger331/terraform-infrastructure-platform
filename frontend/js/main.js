const environments = {
  dev: {
    name: "Development",
    vpcCidr: "10.0.0.0/16",

    publicSubnetA: "10.0.1.0/24",
    publicSubnetB: "10.0.2.0/24",

    privateAppSubnetA: "10.0.11.0/24",
    privateAppSubnetB: "10.0.12.0/24",

    privateDbSubnetA: "10.0.21.0/24",
    privateDbSubnetB: "10.0.22.0/24",

    instanceType: "t3.micro",

    asgCapacity: "2 / 2 / 4",

    statePath:
      "environments/dev/terraform.tfstate"
  },

  prod: {
    name: "Production",
    vpcCidr: "10.1.0.0/16",

    publicSubnetA: "10.1.1.0/24",
    publicSubnetB: "10.1.2.0/24",

    privateAppSubnetA: "10.1.11.0/24",
    privateAppSubnetB: "10.1.12.0/24",

    privateDbSubnetA: "10.1.21.0/24",
    privateDbSubnetB: "10.1.22.0/24",

    instanceType: "t3.small",

    asgCapacity: "2 / 2 / 6",

    statePath:
      "environments/prod/terraform.tfstate"
  }
};


const devButton =
  document.getElementById("devButton");

const prodButton =
  document.getElementById("prodButton");


const fields = {
  environmentName:
    document.getElementById("environmentName"),

  vpcCidr:
    document.getElementById("vpcCidr"),

  instanceType:
    document.getElementById("instanceType"),

  asgCapacity:
    document.getElementById("asgCapacity"),

  statePath:
    document.getElementById("statePath"),

  publicSubnetA:
    document.getElementById("publicSubnetA"),

  publicSubnetB:
    document.getElementById("publicSubnetB"),

  privateAppSubnetA:
    document.getElementById("privateAppSubnetA"),

  privateAppSubnetB:
    document.getElementById("privateAppSubnetB"),

  privateDbSubnetA:
    document.getElementById("privateDbSubnetA"),

  privateDbSubnetB:
    document.getElementById("privateDbSubnetB")
};


function renderEnvironment(environment) {
  const config = environments[environment];

  fields.environmentName.textContent =
    config.name;

  fields.vpcCidr.textContent =
    config.vpcCidr;

  fields.instanceType.textContent =
    config.instanceType;

  fields.asgCapacity.textContent =
    config.asgCapacity;

  fields.statePath.textContent =
    config.statePath;

  fields.publicSubnetA.textContent =
    config.publicSubnetA;

  fields.publicSubnetB.textContent =
    config.publicSubnetB;

  fields.privateAppSubnetA.textContent =
    config.privateAppSubnetA;

  fields.privateAppSubnetB.textContent =
    config.privateAppSubnetB;

  fields.privateDbSubnetA.textContent =
    config.privateDbSubnetA;

  fields.privateDbSubnetB.textContent =
    config.privateDbSubnetB;


  devButton.classList.toggle(
    "active",
    environment === "dev"
  );

  prodButton.classList.toggle(
    "active",
    environment === "prod"
  );
}


devButton.addEventListener(
  "click",
  () => renderEnvironment("dev")
);


prodButton.addEventListener(
  "click",
  () => renderEnvironment("prod")
);


renderEnvironment("dev");