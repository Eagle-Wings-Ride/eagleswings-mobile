// // def largestGood(binString):
// //     # Create a list to store substrings
// //     substrings = []
// //     balance = 0
// //     start = 0
    
// //     # Divide the binary string into balanced good substrings
// //     for i in range(len(binString)):
// //         if binString[i] == '1':
// //             balance += 1
// //         else:
// //             balance -= 1
        
// //         # When balance is zero, it means we have a good substring
// //         if balance == 0:
// //             substrings.append(binString[start:i+1])
// //             start = i + 1
    
// //     # Sort the good substrings in descending order to get the largest binary value
// //     substrings.sort(reverse=True)
    
// //     # Join the substrings to form the largest possible good string
// //     return ''.join(substrings)





// import { useState, useEffect } from "react";
// import { Link, useNavigate } from "react-router-dom";
// import { BeatLoader } from "react-spinners";
// import { Table, Pagination, Modal, Tab, Tabs } from "react-bootstrap";

// import { deleteClient, referrers, updateClient } from "../api/post";
// import CopyPanel from "../components/copyPanel";
// import ShareSocial from "../components/shareSocial";
// import CopyBtn from "../components/copyBtn";
// import {
//   BsCodeSlash,
//   BsX,
//   BsCreditCard2Front,
//   BsTags,
//   BsPencilFill,
//   BsFillArrowUpCircleFill,
//   BsFillArrowDownCircleFill
// } from "react-icons/bs";

// import Layout from "../components/layout";
// import ButtonEle from "../components/buttonEle";
// import SendMsg from "../components/sendmsg";
// import { randomStringRef, encrypt, decrypt } from "../service";
// import SaveReward from "../components/saveReward";
// import Confirm from "../components/confirmation";
// import TextField from "../components/textField";
// import RTable from "../components/rTable";

// function Dashboard(props: any) {
//   const [campaigns, setCampaigns] = useState([]);
//   const [campaignId, setCampaignId] = useState("");
//   const [campaignReferral, setCampaignReferral] = useState("");
//   const [campaignName, setCampaignName] = useState("");
//   const [err, setErr] = useState("");
//   const [success, setSuccess] = useState("");

//   const [msgShow, setMsgShow] = useState(false);
//   const toggleMsgShow = () => setMsgShow(!msgShow);

//   const [createShow, setCreateShow] = useState(false);
//   const toggleCreateShow = () => setCreateShow(!createShow);

//   const [editShow, setEditShow] = useState(false);
//   const toggleEditShow = () => setEditShow(!editShow);

//   const [embedShow, setEmbedShow] = useState(false);
//   const toggleEmbedShow = () => setEmbedShow(!embedShow);

//   const [rewardShow, setRewardShow] = useState(false);
//   const toggleRewardShow = () => setRewardShow(!rewardShow);

//   const navigate = useNavigate();

//   var index = 0;

//   const getReferrers = async () => {
//     index++;
//     setErr("");

//     props.setLoading(true);
//     const res = await referrers({ email: props.userinfo.email });
//     if (res.data) {
//       if (res.data.data) {
//         if (res.data.data.length > 0) {
//           setCampaigns(res.data.data);
//         } else {
//           setCampaigns([]);
//           setErr("No data");
//         }
//       } else {
//         setErr(res.err);
//       }
//     } else {
//       setErr(res.err);
//     }
//     props.setLoading(false);
//   };

//   useEffect(() => {
//     if (index === 0 && props.userinfo.email) getReferrers();
//   }, [JSON.stringify(props.userinfo)]);

//   const handle = async () => {
//     if (!campaignName) return;

//     await props.submit(true, campaignName);
//     setCampaignName("");
//     toggleCreateShow();
//     getReferrers();
//   };

//   const deleteCampaign = async (id: string) => {
//     if (await Confirm("Are you sure you want to delete?")) {
//       const res = await deleteClient({ id });
//       if (res.data) {
//         if (res.data.success) {
//           getReferrers();
//         } else {
//           setErr(res.err);
//         }
//       } else {
//         setErr(res.err);
//       }
//     }
//   };

//   const generateReferrer = (value: string) => {
//     const code: string = randomStringRef(4);
//     return encrypt(value + code);
//   };

//   const snippetCode = `<!-- Reward Embed Script Start -->
//       <form id="sform" method="post" action="${
//         process.env.REACT_APP_BACKEND_URL
//       }/saveinfo" onsubmit="return false;">
//         <input type="hidden" value="${randomStringRef(5)}" name="id" />
//         <div>
//           <p>Email Address<span style="color: #f42f3b">*</span></p>
//           <input id="email" placeholder="Enter your email address" name="email" type="text" />
//         </div>
//         <div>
//           <p>Name</p>
//           <input placeholder="Enter your name" name="name" type="text" />
//         </div>
//         <input type="hidden" value="${campaignReferral}" name="referral" />
//         <input type="hidden" value="${generateReferrer(
//           decrypt(campaignReferral.replace(/(crypt)/gm, "/"))
//         )}" name="referrer" />
//         <button onclick="onSubmit()" style="margin-top: 20px">Submit</button>
//       </form>
//       <script>
//         function onSubmit() {
//           if (!document.getElementById("email").value) {
//             document.getElementById("email").focus();
//             return;
//           }
//           document.getElementById("sform").submit();
//         }

//         document.getElementById("sform").addEventListener('keypress', function(e) {
//           if (e.keyCode === 13) {
//             e.preventDefault();
//           }
//         });
//       </script>
//     <!-- Reward Embed Script End -->`;

//   const snippetCode2 = `<!-- Webclass Embed Script Start -->
//     <form id="sform" method="post" action="${
//       process.env.REACT_APP_BACKEND_URL
//     }/saveinfo"  onsubmit="return false;">
//       <input type="hidden" value="${randomStringRef(5)}" name="id" />
//       <div>
//         <p>Email Address<span style="color: #f42f3b">*</span></p>
//         <input id="email" placeholder="Enter your email address" name="email" type="text" />
//       </div>
//       <div>
//         <p>Name</p>
//         <input placeholder="Enter your name" name="name" type="text" />
//       </div>
//       <div>
//         <p>Phone</p>
//         <input placeholder="Type your phone number" name="phone" type="text" />
//       </div>
//       <input type="hidden" id="referral" value="" name="referral" />
//       <input type="hidden" value="" name="referrer" />
//       <button onclick="onSubmit()" style="margin-top: 20px">Submit</button>
//     </form>
//     <script>
//       const queryString = window.location.search;
//       const urlParams = new URLSearchParams(queryString);
//       document.getElementById("referral").value=urlParams.get('referralCode');

//       function onSubmit() {
//         if (!document.getElementById("email").value) {
//           document.getElementById("email").focus();
//           return;
//         }
//         document.getElementById("sform").submit();
//       }

//       document.getElementById("sform").addEventListener('keypress', function(e) {
//         if (e.keyCode === 13) {
//           e.preventDefault();
//         }
//       });
//     </script>
//   <!-- Webclass Embed Script End -->`;

//   const updateCampaignName = async () => {
//     props.setLoading(true);
//     await updateClient({
//       email: props.userinfo.email,
//       campaignName: campaignName,
//       id: campaignId
//     });
//     let campaignArr: any = [...campaigns];
//     for (let k = 0; k < campaignArr.length; k++) {
//       if (campaignArr[k].id === campaignId) {
//         campaignArr[k].campaignName = campaignName;
//         break;
//       }
//     }
//     setCampaigns(campaignArr);

//     setSuccess("The campaign name is updated.");
//     setCampaignId("");
//     setCampaignName("");
//     toggleEditShow();

//     props.setLoading(false);
//   };

//   useEffect(() => {
//     if (success) {
//       setTimeout(() => {
//         setSuccess("");
//       }, 4000);
//     }
//   }, [success]);

//   return (
//     <Layout userinfo={props.userinfo}>
//       <div className="sub-container">
//         <div className="content">
//           <div
//             className="d-md-flex justify-content-between"
//             style={{ marginBottom: 20 }}
//           >
//             <h2 className="title">dashboard</h2>
          
//             <ButtonEle title="+ New campaign" handle={toggleCreateShow} />
//           </div>
//           {campaigns.length > 0 && (
//             <RTable
//               columns={[
//                 {
//                   Header: "Name",
//                   accessor: "campaignName"
//                 },
//                 {
//                   Header: "Active Campaigns",
//                   accessor: "url",
//                   Cell: ({ cell }: any) => (
//                     <div style={{ display: "flex" }}>
//                       <div>
//                         {`${window.location.origin}/referral/${cell.value}`}
//                       </div>
//                       <div
//                         style={{
//                           position: "relative",
//                           marginLeft: 10,
//                           top: -4
//                         }}
//                       >
//                         <CopyBtn
//                           value={`${window.location.origin}/referral/${cell.value}`}
//                         />
//                       </div>
//                     </div>
//                   ),
//                   disableSortBy: true
//                 },
//                 {
//                   Header: "Ambassadors",
//                   accessor: "count",
//                   disableSortBy: true
//                 },
//                 {
//                   Header: "Referrals",
//                   accessor: "count1",
//                   disableSortBy: true
//                 },
//                 {
//                   Header: "Date",
//                   accessor: "date"
//                 },
//                 {
//                   Header: "Referral Rate",
//                   accessor: "type",
//                   Cell: ({ cell }: any) => (
//                     <span>
//                       {cell.row.original.count > 0
//                         ? (
//                             cell.row.original.count1 / cell.row.original.count
//                           ).toFixed(2)
//                         : 0}
//                     </span>
//                   )
//                 },
//                 {
//                   Header: "Actions",
//                   accessor: "id",
//                   Cell: ({ cell }: any) => (
//                     <div className="data-row d-flex justify-content-center">
//                       <div
//                         className="analytics pt-1"
//                         onClick={() =>
//                           navigate(`/campaigns/${cell.row.original.url}`)
//                         }
//                         style={{ marginLeft: 20 }}
//                       >
                   
//                         <div style={{ marginLeft: 5 }}>Analytics</div>
//                       </div>
                    
//                       {cell.row.original.type === "creator" && (
//                         <div
//                           className="analytics pt-1"
//                           style={{ marginLeft: 20 }}
//                           onClick={() => {
//                             navigate(
//                               `/campaign/${cell.row.original.url}/rewards`
//                             );
//                           }}
//                         >
//                           <div>
//                             <BsCreditCard2Front size={20} />
//                           </div>
//                           <div style={{ marginLeft: 5 }}>Rewards</div>
//                         </div>
//                       )}
//                       {cell.row.original.type === "creator" && (
//                         <div
//                           className="analytics delete-icon pt-1"
//                           onClick={() => {
//                             deleteCampaign(cell.value);
//                           }}
//                           style={{ marginLeft: 20 }}
//                         >
//                           <BsX size={25} />
//                         </div>
//                       )}
//                       {cell.row.original.type === "creator" && (
//                         <div
//                           className="analytics delete-icon pt-1"
//                           onClick={() => {
//                             setCampaignId(cell.value);
//                             setCampaignName(cell.row.original.campaignName);
//                             toggleEditShow();
//                           }}
//                           style={{ marginLeft: 10 }}
//                         >
//                           <BsPencilFill />
//                         </div>
//                       )}
//                     </div>
//                   ),
//                   disableSortBy: true
//                 }
//               ]}
//               data={campaigns}
//             />
//           )}

//           {err && <p className="err p-3">{err}</p>}
//           {success && <p className="success">{success}</p>}
//           {props.loading && (
//             <div className="loading">
//               <BeatLoader color="#f42f3b" size={12} />
//             </div>
//           )}
//         </div>
//       </div>
//       <Modal show={msgShow} onHide={toggleMsgShow}>
//         <Modal.Header closeButton>
//           <Modal.Title>Add Campaign</Modal.Title>
//         </Modal.Header>
//         <Modal.Body>
//           <SendMsg campaignId={campaignId} />
//         </Modal.Body>
//       </Modal>
//       <Modal show={createShow} onHide={toggleCreateShow}>
//         <Modal.Header closeButton>
//           <Modal.Title>Campaign name</Modal.Title>
//         </Modal.Header>
//         <Modal.Body>
//           <TextField
//             title="Please insert campaign name"
//             placeholder=""
//             required={true}
//             value={campaignName}
//             setValue={setCampaignName}
//           />
//           <div className="mt-2" style={{ textAlign: "center" }}>
//             <ButtonEle title="Save" handle={handle} />
//           </div>
//         </Modal.Body>
//       </Modal>
//       <Modal show={editShow} onHide={toggleEditShow}>
//         <Modal.Header closeButton>
//           <Modal.Title>Edit campaign name</Modal.Title>
//         </Modal.Header>
//         <Modal.Body>
//           <TextField
//             title="Please insert campaign name"
//             placeholder=""
//             required={false}
//             value={campaignName}
//             setValue={setCampaignName}
//           />
//           <div className="mt-2" style={{ textAlign: "center" }}>
//             <ButtonEle title="Save" handle={() => updateCampaignName()} />
//           </div>
//         </Modal.Body>
//       </Modal>
//       <Modal show={embedShow} onHide={toggleEmbedShow}>
//         <Modal.Header closeButton>
//           <Modal.Title>Embed&nbsp;Script</Modal.Title>
//         </Modal.Header>
//         <Modal.Body>
//           <Tabs defaultActiveKey="reward" transition={false} className="mb-3">
//             <Tab eventKey="reward" title="Reward">
//               <div className="embed-script">
//                 {`<!-- Reward Embed Script Start -->`}
//                 <br />
//                 {`<form method="post" action="${process.env.REACT_APP_BACKEND_URL}/saveinfo">`}
//                 <br />
//                 &nbsp;
//                 {`<input type="hidden" value="${randomStringRef(
//                   5
//                 )}" name="id" />`}
//                 <br />
//                 {`<div>`}
//                 <br />
//                 &nbsp;
//                 {`<p>Email Address<span style="color: #f42f3b">*</span></p>`}
//                 <br />
//                 &nbsp;
//                 {`<input placeholder="Enter your email address" name="email" type="text" />`}
//                 <br />
//                 {`</div>`}
//                 <br />
//                 {`<div>`}
//                 <br />
//                 &nbsp;{`<p>Name</p>`}
//                 <br />
//                 &nbsp;
//                 {`<input placeholder="Enter your name" name="name" type="text" />`}
//                 <br />
//                 {`</div>`}
//                 <br />
//                 &nbsp;
//                 {`<input type="hidden" value="${campaignReferral}" name="referral" />`}
//                 <br />
//                 &nbsp;
//                 {`<input type="hidden" value="${generateReferrer(
//                   decrypt(campaignReferral.replace(/(crypt)/gm, "/"))
//                 )}" name="referrer" />`}
//                 <br />
//                 &nbsp;{`<input type="submit" value="submit" />`}
//                 <br />
//                 {`</form>`}
//                 <br />
//                 {`<!-- Reward Embed Script End -->`}
//               </div>
//               <div style={{ height: 100 }}>
//                 <div
//                   className="copy-button"
//                   style={{
//                     marginTop: 20,
//                     float: "right",
//                     width: 100
//                   }}
//                 >
//                   <CopyBtn value={snippetCode} btn={true} />
//                 </div>
//               </div>
//             </Tab>
//             <Tab eventKey="webclass" title="Webclass">
//               <div className="embed-script">
//                 {`<!-- Webclass Embed Script Start -->`}
//                 <br />
//                 {`<form method="post" action="${process.env.REACT_APP_BACKEND_URL}/saveinfo">`}
//                 <br />
//                 &nbsp;
//                 {`<input type="hidden" value="${randomStringRef(
//                   5
//                 )}" name="id" />`}
//                 <br />
//                 {`<div>`}
//                 <br />
//                 &nbsp;
//                 {`<p>Email Address<span style="color: #f42f3b">*</span></p>`}
//                 <br />
//                 &nbsp;
//                 {`<input placeholder="Enter your email address" name="email" type="text" />`}
//                 <br />
//                 {`</div>`}
//                 <br />
//                 {`<div>`}
//                 <br />
//                 &nbsp;{`<p>Name</p>`}
//                 <br />
//                 &nbsp;
//                 {`<input placeholder="Enter your name" name="name" type="text" />`}
//                 <br />
//                 {`</div>`}
//                 <br />
//                 {`<div>`}
//                 <br />
//                 &nbsp;{`<p>Phone</p>`}
//                 <br />
//                 &nbsp;
//                 {`<input placeholder="Type your phone number" name="phone" type="text" />`}
//                 <br />
//                 {`</div>`}
//                 <br />
//                 {`<input type="hidden" value="${campaignReferral}" name="referral" />`}
//                 <br />
//                 &nbsp;{`<input type="hidden" value="" name="referrer" />`}
//                 <br />
//                 &nbsp;{`<input type="submit" value="submit" />`}
//                 <br />
//                 {`</form>`}
//                 <br />
//                 {`<script>`}
//                 <br />
//                 {`const queryString = window.location.search;`}
//                 <br />
//                 {`const urlParams = new URLSearchParams(queryString);`}
//                 <br />
//                 {`document.getElementById("referral").value=urlParams.get('referralCode');`}
//                 <br />
//                 {`</script>`}
//                 {`<!-- Webclass Embed Script End -->`}
//               </div>
//               <div
//                 className="copy-button"
//                 style={{ marginTop: 20, float: "right", width: 100 }}
//               >
//                 <CopyBtn value={snippetCode2} btn={true} />
//               </div>
//             </Tab>
//           </Tabs>
//         </Modal.Body>
//       </Modal>
//       <Modal show={rewardShow} onHide={toggleRewardShow}>
//         <Modal.Header closeButton>
//           <Modal.Title>Rewards</Modal.Title>
//         </Modal.Header>
//         <Modal.Body>
//           <SaveReward campaignId={campaignId} />
//         </Modal.Body>
//       </Modal>
//     </Layout>
//   );
// }

// export default Dashboard;