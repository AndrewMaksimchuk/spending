import Entry from "@/components/Entry";
import Dashboard from "@/components/Dashboard";

const routes = [
	{
		path: "/",
		name: "Entry",
		component: Entry,
	},
	{
		path: "/dashboard",
		name: "Dashboard",
		component: Dashboard,
	},
];

export default routes;
